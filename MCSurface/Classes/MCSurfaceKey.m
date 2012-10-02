//
//  MCSurfaceParallaxedTileKey.m
//  GQ
//
//  Created by Baglan on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCSurfaceKey.h"

@implementation MCSurfaceKey

@synthesize type = _type;
@synthesize object = _object;
@synthesize hideWhenRecycled = _hideWhenRecycled;

- (id)initWithType:(id)type object:(id)object rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal
{
    self = [super init];
    if (self != nil) {
        _rect = rect;
        _verticalParallaxRatio = vertical;
        _horizontalParallaxRatio = horizontal;
        _object = object;
        _type = type;
        _hideWhenRecycled = NO;
    }
    return self;
}

- (id)initWithType:(id)type object:(id)object rect:(CGRect)rect
{
    return [self initWithType:type object:object rect:rect verticalParallaxRatio:1.0 horizontalParallaxRatio:1.0];
}

- (CGRect)getRectForSurfaceView:(MCSurfaceView *)surfaceView
{
    CGRect rect = _rect;
    CGPoint contentOffset = surfaceView.scrollView.contentOffset;
    rect.origin = CGPointMake(rect.origin.x - contentOffset.x * (_horizontalParallaxRatio - 1),
                              rect.origin.y - contentOffset.y * (_verticalParallaxRatio - 1));
    return rect;
}

- (CGAffineTransform)transformForContentOffset:(CGPoint)contentOffset
{
    return CGAffineTransformMakeTranslation(-contentOffset.x * _horizontalParallaxRatio,
                                            -contentOffset.y * _verticalParallaxRatio);
}

- (void)surfaceView:(MCSurfaceView *)surfaceView adjustView:(UIView *)view
{
    CGPoint contentOffset = surfaceView.scrollView.contentOffset;
    view.transform = [self transformForContentOffset:contentOffset];
}

- (UIView *)surfaceViewGetView:(MCSurfaceView *)surfaceView
{
    UIView *view = nil;
    
    view = [surfaceView dequeueViewForRecyclingKey:_type];
    if (!view) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:_type owner:self options:nil];
        view = [objects objectAtIndex:0];
        NSLog(@"--- alloc");
    } else {
        NSLog(@"--- dequeue");
    }
    
    view.hidden = NO;
    view.transform = CGAffineTransformIdentity;
    view.frame = [self getRectForSurfaceView:surfaceView];
    
    return view;
}

@end
