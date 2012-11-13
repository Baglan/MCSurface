//
//  MCSurfaceImageKey.m
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "MCSurfaceImageKey.h"
#import <QuartzCore/QuartzCore.h>

@implementation MCSurfaceImageKey

- (id)initWithImage:(UIImage *)image rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex
{
    self = [super initWithType:NSStringFromClass(self.class) object:image rect:rect verticalParallaxRatio:vertical horizontalParallaxRatio:horizontal zIndex:zIndex];
    return self;
}

- (id)initWithImageName:(NSString *)imageName rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex
{
    self = [super initWithType:NSStringFromClass(self.class) object:imageName rect:rect verticalParallaxRatio:vertical horizontalParallaxRatio:horizontal zIndex:zIndex];
    return self;
}

- (UIView *)surfaceViewGetView:(MCSurfaceView *)surfaceView
{
    UIImageView * view = nil;
    
    view = (UIImageView *)[surfaceView dequeueViewForRecyclingKey:NSStringFromClass(self.class)];
    if (!view) {
        view = [[UIImageView alloc] init];
    }
    
    if ([self.object isKindOfClass:NSString.class]) {
        view.image = [UIImage imageNamed:self.object];
    } else if ([self.object isKindOfClass:UIImage.class]) {
        view.image = self.object;
    }
    
    if (self.hideWhenRecycled) {
        view.hidden = NO;
    }
    view.transform = CGAffineTransformIdentity;
    view.frame = _rect;
    view.layer.zPosition = _zIndex;
    
    return view;
}

@end
