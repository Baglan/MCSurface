//
//  MCSurfaceImageKey.h
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "MCSurfaceKey.h"

@interface MCSurfaceImageKey : MCSurfaceKey

- (id)initWithImage:(UIImage *)image rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex;
- (id)initWithImageName:(NSString *)imageName rect:(CGRect)rect verticalParallaxRatio:(CGFloat)vertical horizontalParallaxRatio:(CGFloat)horizontal zIndex:(int)zIndex;

@end
