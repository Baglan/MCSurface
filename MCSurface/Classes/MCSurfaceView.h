//
//  MCSurfaceView.h
//  MCSurface
//
//  Created by Baglan Dosmagambetov on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MCSURFACE_SCROLLING_STARTED_NOTIFICATION        @"MCSURFACE_SCROLLING_STARTED_NOTIFICATION"
#define MCSURFACE_DIRECTION_LOCKED_NOTIFICATION         @"MCSURFACE_DIRECTION_LOCKED_NOTIFICATION"
#define MCSURFACE_SCROLLING_ENDED_NOTIFICATION          @"MCSURFACE_SCROLLING_ENDED_NOTIFICATION"
#define MCSURFACE_DRAGGED_OFF_THE_EDGE_NOTIFICATION     @"MCSURFACE_DRAGGED_OFF_THE_EDGE_NOTIFICATION"
#define MCSURFACE_DELAYED_SCROLLING_ENDED_NOTIFICATION  @"MCSURFACE_DELAYED_SCROLLING_ENDED_NOTIFICATION"
#define MCSURFACE_PAGE_CHANGED_NOTIFICATION             @"MCSURFACE_PAGE_CHANGED_NOTIFICATION"

enum MCSurfaceView_ScrollDirection {
    MCSurfaceView_ScrollDirectionUndecided,
    MCSurfaceView_ScrollDirectionVertical,
    MCSurfaceView_ScrollDirectionHorizontal
};

@protocol MCSurfaceDataSource;

@interface MCSurfaceView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id<MCSurfaceDataSource> dataSource;
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,retain) NSArray * keys;

@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, assign) NSInteger page;
- (void)setPage:(NSInteger)page animated:(BOOL)animated;

@property (nonatomic, readonly) BOOL offLeftEdge;
@property (nonatomic, readonly) BOOL offRightEdge;
@property (nonatomic, readonly) BOOL offTopEdge;
@property (nonatomic, readonly) BOOL offBottomEdge;
@property (nonatomic, assign) CGFloat edgeThreshold;

@property (nonatomic, assign) BOOL zoomingEnabled;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) CGFloat mimimumZoomScale;
@property (nonatomic, assign) CGFloat maximumZoomScale;

@property (nonatomic, readonly) BOOL scrolling;
@property (nonatomic, assign) BOOL directionLockEnabled;
@property (nonatomic, readonly) enum MCSurfaceView_ScrollDirection scrollDirection;

- (void)reloadData;
- (UIView *)dequeueViewForRecyclingKey:(id)key;

@end

@protocol MCSurfaceDataSource <NSObject>

- (NSArray *)getAllKeysForSurfaceView:(MCSurfaceView *)surfaceView;

@end