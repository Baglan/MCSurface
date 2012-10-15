//
//  MCSurfaceView.h
//  MCSurface
//
//  Created by Baglan Dosmagambetov on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCSurfaceDataSource;

@interface MCSurfaceView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id<MCSurfaceDataSource> dataSource;
@property (nonatomic,readonly) UIScrollView *scrollView;

- (void)reloadData;
- (UIView *)dequeueViewForRecyclingKey:(id)key;

@end

@protocol MCSurfaceDataSource <NSObject>

- (NSArray *)getAllKeysForSurfaceView:(MCSurfaceView *)surfaceView;

@end