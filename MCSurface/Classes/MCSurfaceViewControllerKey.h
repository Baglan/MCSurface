//
//  MCSurfaceViewControllerKey.h
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "MCSurfaceKey.h"

@interface MCSurfaceViewControllerKey : MCSurfaceKey

- (id)initWithRect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex;
- (UIViewController *)createController;
- (void)updateController:(id)controller;

- (id)controllerForView:(id)view;

@end
