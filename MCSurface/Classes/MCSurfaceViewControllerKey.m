//
//  MCSurfaceViewControllerKey.m
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "MCSurfaceViewControllerKey.h"
#import <QuartzCore/QuartzCore.h>

@interface MCSurfaceViewControllerKey ()

@property (nonatomic, readonly) NSMutableSet * controllersCache;

@end


@implementation MCSurfaceViewControllerKey

- (id)initWithRect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex
{
    self = [super initWithType:NSStringFromClass(self.class) object:nil rect:rect verticalParallaxRatio:vertical horizontalParallaxRatio:horizontal zIndex:zIndex];
    return self;
}

- (NSMutableSet *)controllersCache
{
    __strong static NSMutableSet * cache;
    if (!cache) {
        cache = [NSMutableSet set];
    }
    return cache;
}

- (id)controllerForView:(id)view
{
    __block id controller = nil;
    NSMutableSet * cache = self.controllersCache;
    [cache enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIViewController * cc = obj;
        if (cc.view == view) {
            controller = cc;
            *stop = YES;
        }
    }];
    return controller;
}

- (UIViewController *)createController
{
    UIViewController * controller = [[UIViewController alloc] init];
    return controller;
}

- (void)updateController:(id)controller
{
    // To be implemeted by extending classes
}

- (UIView *)surfaceViewGetView:(MCSurfaceView *)surfaceView
{
    UIView * view = nil;
    
    view = [surfaceView dequeueViewForRecyclingKey:NSStringFromClass(self.class)];
    if (!view) {
        UIViewController * controller = [self createController];
        [self.controllersCache addObject:controller];
        view = controller.view;
    }
    UIViewController * controller = [self controllerForView:view];
    [self updateController:controller];
    
    if (self.hideWhenRecycled) {
        view.hidden = NO;
    }
    view.transform = CGAffineTransformIdentity;
    view.frame = _rect;
    view.layer.zPosition = _zIndex;
    
    return view;
}

- (BOOL)hideWhenRecycled
{
    return YES;
}

@end
