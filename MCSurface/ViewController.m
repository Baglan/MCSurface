//
//  ViewController.m
//  MCSurface
//
//  Created by Baglan Dosmagambetov on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MCSurfaceKey.h"
#import "MCSurfaceImageKey.h"
#import "MyViewControllerKey.h"
#import "ColorViewControllerKey.h"

@interface ViewController ()

@end

@implementation ViewController {
    MCSurfaceView *_surfaceView;
    CGRect _visibleRect;
    NSSet *_keys;
    NSDictionary *_rects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _surfaceView = [[MCSurfaceView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_surfaceView];
    _surfaceView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _surfaceView.dataSource = self;
    _surfaceView.backgroundColor = [UIColor whiteColor];
    
    [_surfaceView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _surfaceView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark MCSurfaceDataSource

- (NSArray *)getAllKeysForSurfaceView:(MCSurfaceView *)surfaceView
{
    surfaceView.scrollView.contentSize = CGSizeMake(12000, surfaceView.frame.size.height);
    
    NSMutableArray *allKeys = [NSMutableArray array];
    
    for (int i=0; i<50; i++) {
        MCSurfaceKey *key = [[MCSurfaceKey alloc] initWithType:@"RedSquare" object:nil rect:CGRectMake(200 * i, 100, 100, 100) verticalParallaxRatio:1 horizontalParallaxRatio:1 zIndex:2];
        [allKeys addObject:key];
    }
    
    for (int i=0; i<100; i++) {
        MCSurfaceKey *key = [[MCSurfaceKey alloc] initWithType:@"GreenSquare" object:nil rect:CGRectMake(300 * i, 50, 200, 200) verticalParallaxRatio:1 horizontalParallaxRatio:0.5 zIndex:1];
        [allKeys addObject:key];
    }
    
    // Clouds
    NSArray * cloudImageNames = @[@"cloud-1",@"cloud-2",@"cloud-3"];
    for (int i=0; i<100; i++) {
        NSString * imageName = cloudImageNames[i%cloudImageNames.count];
        CGRect imageRect = CGRectMake(i * 320, 0, 320, 568);
        MCSurfaceImageKey *key = [[MCSurfaceImageKey alloc] initWithImageName:imageName rect:imageRect verticalParallaxRatio:0 horizontalParallaxRatio:1.2 zIndex:-1];
        [allKeys addObject:key];
    }
    
    // Greetings
    for (int i=0; i<100; i++) {
        CGRect colorRect = CGRectMake(i * 320 * 2, 400, 320, 320);
        MyViewControllerKey *key = [[MyViewControllerKey alloc] initWithRect:colorRect verticalParallaxRatio:0 horizontalParallaxRatio:0.8 zIndex:20];
        [allKeys addObject:key];
    }
    
    // Colors
    for (int i=0; i<100; i++) {
        CGRect colorRect = CGRectMake(i * 320 * 2 + 50, 100, 200, 200);
        ColorViewControllerKey *key = [[ColorViewControllerKey alloc] initWithRect:colorRect verticalParallaxRatio:0 horizontalParallaxRatio:0.6 zIndex:20];
        [allKeys addObject:key];
    }
    
    return allKeys;
}

@end
