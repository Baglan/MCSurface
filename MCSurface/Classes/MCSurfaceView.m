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
#import <QuartzCore/QuartzCore.h>

#define MCSURFACE_EDGE_THRESHOLD    40.0
#define MCSURFACE_NOTIFICATION_DELAY 0.2

@interface MCSurfaceView () <UIGestureRecognizerDelegate> {
    
}

@end

@implementation MCSurfaceView {
    NSMutableSet *_allKeys;
    NSMutableSet *_visibleKeys;
    NSMutableSet *_visibleViews;
    MCRecycleBin *_recyclingBin;
    CGPoint _initialContentOffset;
    BOOL _scrolling;
    UIPinchGestureRecognizer * _pinchGestureRecognizer;
    NSTimer * _delayedNotificationTimer;
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
    
    _scrolling = NO;
    _directionLockEnabled = NO;
    self.pagingEnabled = NO;
    
    _edgeThreshold = MCSURFACE_EDGE_THRESHOLD;
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    _pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_pinchGestureRecognizer];
    
    _zoomScale = 1.0;
    _mimimumZoomScale = 1.0;
    _maximumZoomScale = 1.0;
    self.zoomingEnabled = NO;
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
    CGRect visibleRect = self.bounds;
    
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
    NSMutableArray * views = [NSMutableArray array];
    [_visibleViews enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MCSurfaceKey *key = [(NSDictionary *)obj objectForKey:@"key"];
        UIView *view = [(NSDictionary *)obj objectForKey:@"view"];
        [key surfaceView:self adjustView:view];
        [views addObject:view];
    }];
    
    // Re-order subviews by layer zPosition
    // This is necessary to preserve the correct responder chain
    NSArray * sortedViews = [views sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView * a = obj1;
        UIView * b = obj2;
        return a.layer.zPosition > b.layer.zPosition ? NSOrderedDescending : (a.layer.zPosition < b.layer.zPosition ? NSOrderedAscending : NSOrderedSame);
    }];
    
    [sortedViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView * view = obj;
        [self bringSubviewToFront:view];
    }];
}

#pragma mark -
#pragma mark Keys property

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

#pragma mark -
#pragma mark Zoom

- (void)setZoomingEnabled:(BOOL)zoomingEnabled
{
    _pinchGestureRecognizer.enabled = zoomingEnabled;
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer
{
    _zoomScale *= recognizer.scale;
    _zoomScale = _zoomScale < _mimimumZoomScale ? _mimimumZoomScale : _zoomScale;
    _zoomScale = _zoomScale > _maximumZoomScale ? _maximumZoomScale : _zoomScale;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark -
#pragma mark Pages

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    self.scrollView.pagingEnabled = pagingEnabled;
}

- (BOOL)pagingEnabled
{
    return self.scrollView.pagingEnabled;
}

- (NSInteger)page
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    return roundf(contentOffset.x / self.bounds.size.width);
}

- (void)setPage:(NSInteger)page animated:(BOOL)animated
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = self.bounds.size.width * page;
    [self.scrollView setContentOffset:contentOffset animated:animated];
}

- (void)setPage:(NSInteger)page
{
    [self setPage:page animated:NO];
}

#pragma mark -
#pragma mark Scroll direction and notifications

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollDirection = MCSurfaceView_ScrollDirectionUndecided;
    _initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_scrolling) {
        _scrolling = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:MCSURFACE_SCROLLING_STARTED_NOTIFICATION object:self];
    }
    
    if (_delayedNotificationTimer) {
        [_delayedNotificationTimer invalidate];
        _delayedNotificationTimer = nil;
    }
    
    if (_directionLockEnabled) {
        if (scrollView.dragging && _scrollDirection == MCSurfaceView_ScrollDirectionUndecided) {
            CGPoint contentOffset = scrollView.contentOffset;
            double deltaX = fabs(contentOffset.x - _initialContentOffset.x);
            double deltaY = fabs(contentOffset.y - _initialContentOffset.y);
            
            if (deltaX > deltaY) {
                _scrollDirection = MCSurfaceView_ScrollDirectionHorizontal;
            } else {
                _scrollDirection = MCSurfaceView_ScrollDirectionVertical;
            }
        }
        
        // Compensate for direction lock
        if (_scrollDirection == MCSurfaceView_ScrollDirectionHorizontal) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, _initialContentOffset.y);
        }
        
        if (_scrollDirection == MCSurfaceView_ScrollDirectionVertical) {
            scrollView.contentOffset = CGPointMake(_initialContentOffset.x, scrollView.contentOffset.y);
        }
    }
    
    if (scrollView.isDragging) {
        _offLeftEdge = scrollView.contentOffset.x < -_edgeThreshold;
        _offRightEdge = scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width + _edgeThreshold;
        _offTopEdge = scrollView.contentOffset.y < -_edgeThreshold;
        _offBottomEdge = scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + _edgeThreshold;
        
        if (_offLeftEdge || _offRightEdge || _offTopEdge || _offBottomEdge) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MCSURFACE_DRAGGED_OFF_THE_EDGE_NOTIFICATION object:self];
        }
    }
    
    [self setNeedsLayout];
}

- (void)scrollViewAdjustToClosest:(UIScrollView *)scrollView;
{
    if (!scrollView.dragging) {
        _scrollDirection = MCSurfaceView_ScrollDirectionUndecided;
        CGPoint offset = scrollView.contentOffset;
        CGSize size = scrollView.bounds.size;
        CGFloat offsetX = roundf(offset.x / size.width) * size.width;
        CGFloat offsetY = roundf(offset.y / size.height) * size.height;
        offset = CGPointMake(offsetX, offsetY);
        [scrollView setContentOffset:offset];
    }
}

- (void)delayedScrollViewDidEndScrolling
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MCSURFACE_DELAYED_SCROLLING_ENDED_NOTIFICATION object:self];
}


- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView
{
    if (_scrolling) {
        _scrolling = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCSURFACE_SCROLLING_ENDED_NOTIFICATION object:self];
    
    if (self.pagingEnabled) {
        [self scrollViewAdjustToClosest:scrollView];
    }
    
    [_delayedNotificationTimer invalidate];
    _delayedNotificationTimer = nil;
    
    _delayedNotificationTimer = [NSTimer scheduledTimerWithTimeInterval:MCSURFACE_NOTIFICATION_DELAY target:self selector:@selector(delayedScrollViewDidEndScrolling) userInfo:nil repeats:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndScrolling:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrolling:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrolling:scrollView];
}

@end
