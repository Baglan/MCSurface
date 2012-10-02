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

@interface ViewController ()

@end

@implementation ViewController {
    MCSurfaceView *_surfaceView;
    CGRect _visibleRect;
    NSSet *_keys;
    NSDictionary *_rects;
}

- (void)populateRects
{
    NSMutableDictionary *rects = [NSMutableDictionary dictionary];
    
    for (int i=0; i<30; i++) {
        NSString *key = [NSString stringWithFormat:@"a-%d", i];
        CGRect frame = CGRectMake(500 * i, 200, 320, 320);
        NSValue *frameValue = [NSValue valueWithCGRect:frame];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: @"A", @"type", frameValue, @"frame", nil];
        
        [rects setObject:data forKey:key];
    }
    
    for (int i=0; i<100; i++) {
        NSString *key = [NSString stringWithFormat:@"b-%d", i];
        CGRect frame = CGRectMake(300 * i, 100, 200, 600);
        NSValue *frameValue = [NSValue valueWithCGRect:frame];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: @"B", @"type", frameValue, @"frame", nil];
        
        [rects setObject:data forKey:key];
    }
    
    for (int i=0; i<100; i++) {
        NSString *key = [NSString stringWithFormat:@"c-%d", i];
        CGRect frame = CGRectMake(100 * i, 370, 50, 50);
        NSValue *frameValue = [NSValue valueWithCGRect:frame];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: @"C", @"type", frameValue, @"frame", nil];
        
        [rects setObject:data forKey:key];
    }
    
    _rects = [NSDictionary dictionaryWithDictionary:rects];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    return allKeys;
}

@end
