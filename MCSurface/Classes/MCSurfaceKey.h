//
//  MCSurfaceParallaxedTileKey.h
//  GQ
//
//  Created by Baglan on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MCSurfaceView.h"

@interface MCSurfaceKey : NSObject {
    CGRect _rect;
    CGFloat _verticalParallaxRatio;
    CGFloat _horizontalParallaxRatio;
}

@property (nonatomic,readonly) id type;
@property (nonatomic,readonly) id object;

/**
 * Whether view should be hidden or removed from hierarchy when recycled.
 * If YES, view will remain in view hierarchy but hidden (view.hidden = YES);
 * If NO, view will be removed from hierarchy;
 * Default in NO.
 */
@property (nonatomic,readonly) BOOL hideWhenRecycled;

- (id)initWithType:(id)type object:(id)object rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal;
- (id)initWithType:(id)type object:(id)object rect:(CGRect)rect;

- (CGRect)getRectForSurfaceView:(MCSurfaceView *)surfaceView;
- (void)surfaceView:(MCSurfaceView *)surfaceView adjustView:(UIView *)view;
- (UIView *)surfaceViewGetView:(MCSurfaceView *)surfaceView;

@end
