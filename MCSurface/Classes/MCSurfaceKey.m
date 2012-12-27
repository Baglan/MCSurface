//
//  MCSurfaceParallaxedTileKey.m
//  GQ
//
//  Created by Baglan on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MCSurfaceKey.h"
#import <QuartzCore/QuartzCore.h>

@implementation MCSurfaceKey

@synthesize type = _type;
@synthesize object = _object;
@synthesize hideWhenRecycled = _hideWhenRecycled;

- (id)initWithType:(id)type object:(id)object rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex
{
    self = [super init];
    if (self != nil) {
        _rect = rect;
        
        _verticalParallaxRatio = vertical;
        _horizontalParallaxRatio = horizontal;
        _zIndex = zIndex;
        
        _object = object;
        _type = type;
        _hideWhenRecycled = NO;
        
        _boundingBox = CGRectInfinite;
    }
    return self;
}

- (id)initWithType:(id)type object:(id)object rect:(CGRect)rect
{
    return [self initWithType:type object:object rect:rect verticalParallaxRatio:1.0 horizontalParallaxRatio:1.0 zIndex:0];
}

- (CGAffineTransform)transformForSurfaceView:(MCSurfaceView *)surfaceView
{
    CGPoint contentOffset = surfaceView.scrollView.contentOffset;
    CGFloat deltaX = -contentOffset.x * _horizontalParallaxRatio;
    CGFloat deltaY = -contentOffset.y * _verticalParallaxRatio;
    
    deltaX = _rect.origin.x + deltaX < _boundingBox.origin.x ? deltaX = _boundingBox.origin.x - _rect.origin.x : deltaX;
    deltaY = _rect.origin.y + deltaY < _boundingBox.origin.y ? deltaX = _boundingBox.origin.y - _rect.origin.y : deltaY;
    
    deltaX = (_rect.origin.x + _rect.size.width) + deltaX > (_boundingBox.origin.x + _boundingBox.size.width) ? deltaX = (_boundingBox.origin.x + _boundingBox.size.width) - (_rect.origin.x + _rect.size.width) : deltaX;
    deltaY = (_rect.origin.y + _rect.size.height) + deltaX > (_boundingBox.origin.y + _boundingBox.size.height) ? deltaX = (_boundingBox.origin.y + _boundingBox.size.height) - (_rect.origin.y + _rect.size.height) : deltaY;
    
    return CGAffineTransformMakeTranslation(deltaX, deltaY);
}

- (CGRect)getRectForSurfaceView:(MCSurfaceView *)surfaceView
{
    return CGRectApplyAffineTransform(_rect, [self transformForSurfaceView:surfaceView]);
}

- (void)surfaceView:(MCSurfaceView *)surfaceView adjustView:(UIView *)view
{
    view.transform = [self transformForSurfaceView:surfaceView];
}

- (UIView *)surfaceViewGetView:(MCSurfaceView *)surfaceView
{
    UIView *view = nil;
    
    view = [surfaceView dequeueViewForRecyclingKey:_type];
    if (!view) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:_type owner:self options:nil];
        view = [objects objectAtIndex:0];
    }
    if (_hideWhenRecycled) {
        view.hidden = NO;
    }
    view.transform = CGAffineTransformIdentity;
    view.frame = _rect;
    view.layer.zPosition = _zIndex;
    
    return view;
}

@end
