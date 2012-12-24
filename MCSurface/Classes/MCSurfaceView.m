//
//  MCSurfaceView.m
//  MCSurface
//
//  Created by Baglan Dosmagambetov on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCSurfaceView.h"
#import "MCRecycleBin.h"
#import "MCSurfaceKey.h"

@implementation MCSurfaceView {
    NSMutableSet *_allKeys;
    NSMutableSet *_visibleKeys;
    NSMutableSet *_visibleViews;
    MCRecycleBin *_recyclingBin;
}

@synthesize dataSource = _dataSource;
@synthesize scrollView = _scrollView;

- (void)commonInit
{
    // _scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scrollView.hidden = YES;
    [self addSubview:_scrollView];
    [self addGestureRecognizer:_scrollView.panGestureRecognizer];
    _scrollView.delegate = self;
    
    // Views and keys
    _allKeys = [NSMutableSet set];
    _visibleViews = [NSMutableSet set];
    _visibleKeys = [NSMutableSet set];
    
    // _recyclingBin
    _recyclingBin = [[MCRecycleBin alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setNeedsLayout];
}

- (UIView *)dequeueViewForRecyclingKey:(id)key
{
    return [_recyclingBin dequeueObjectForKey:key];
}

#pragma mark -
#pragma mark Visible views

- (void)setVisibleView:(UIView *)view forKey:(id)key
{
    [_visibleViews addObject:@{ @"key" : key, @"view" : view }];
    [_visibleKeys addObject:key];
}

- (void)removeVisibleViewForKey:(id)keyToRemove
{
    NSSet *objectsToRemove = [_visibleViews objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        id key = [(NSDictionary *)obj objectForKey:@"key"];
        
        if (key == keyToRemove) {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    [objectsToRemove enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MCSurfaceKey *key = [(NSDictionary *)obj objectForKey:@"key"];
        UIView *view = [(NSDictionary *)obj objectForKey:@"view"];
        
        [_recyclingBin recycleObject:view withKey:key.type];
        if (key.hideWhenRecycled) {
            view.hidden = YES;
        } else {
            [view removeFromSuperview];
        }
        [_visibleViews removeObject:obj];
    }];
    [_visibleKeys removeObject:keyToRemove];
}

#pragma mark -
#pragma mark Visible view calculations

- (NSSet *)keysForVisibleViews
{
    CGRect visibleRect = CGRectMake(_scrollView.contentOffset.x,
                                    _scrollView.contentOffset.y,
                                    self.bounds.size.width,
                                    self.bounds.size.height);
    
    NSMutableSet *visibleKeys = [NSMutableSet set];
    
    [_allKeys enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MCSurfaceKey *key = obj;
        CGRect keyRect = [key getRectForSurfaceView:self];
        if (CGRectIntersectsRect(keyRect, visibleRect)) {
            [visibleKeys addObject:key];
        }
    }];
    
    return visibleKeys;
}

#pragma mark -
#pragma mark Other

- (void)clearAllViewsAndKeys
{
    // Remove all views
    [_visibleViews enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MCSurfaceKey *key = [(NSDictionary *)obj objectForKey:@"key"];
        UIView *view = [(NSDictionary *)obj objectForKey:@"view"];
        
        [_recyclingBin recycleObject:view withKey:key.type];
        if (key.hideWhenRecycled) {
            view.hidden = YES;
        } else {
            [view removeFromSuperview];
        }
    }];
    
    // Reset data
    [_visibleViews removeAllObjects];
    [_visibleKeys removeAllObjects];
    [_allKeys removeAllObjects];
}

- (void)reloadData
{
    [self clearAllViewsAndKeys];

    // Re-populate
    [_allKeys addObjectsFromArray:[_dataSource getAllKeysForSurfaceView:self]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    // Adjust _scrollView content size to reflect the new size
    if (!CGRectEqualToRect(_scrollView.frame, self.bounds)) {
        _scrollView.frame = self.bounds;
    }
    
    // Figure out views to add and remove
    NSSet *newKeys = [self keysForVisibleViews];
    
    NSMutableSet *keysToRemove = [NSMutableSet setWithSet:_visibleKeys];
    [keysToRemove minusSet:newKeys];
        
    [keysToRemove enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [self removeVisibleViewForKey:obj];
    }];
    
    NSMutableSet *keysToAdd = [NSMutableSet setWithSet:newKeys];
    [keysToAdd minusSet:_visibleKeys];
    
    [keysToAdd enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MCSurfaceKey *key = obj;
        UIView *view = [key surfaceViewGetView:self];
        [self setVisibleView:view forKey:obj];
        [self addSubview:view];
    }];
    
    // Update positions for visible views
    [_visibleViews enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MCSurfaceKey *key = [(NSDictionary *)obj objectForKey:@"key"];
        UIView *view = [(NSDictionary *)obj objectForKey:@"view"];
        [key surfaceView:self adjustView:view];
    }];
}

#pragma mark -
#pragma mark Properties

- (void)setKeys:(NSArray *)keys
{
    [self clearAllViewsAndKeys];
    
    [_allKeys addObjectsFromArray:keys];
    
    [self setNeedsLayout];
}

- (NSArray *)keys
{
    return [_allKeys allObjects];
}

@end
