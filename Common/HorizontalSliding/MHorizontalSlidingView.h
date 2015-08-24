//
//  MHorizontalSlidingView.h
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class MHorizontalSlidingView;
@protocol MHorizontalSlidingViewDelegate <NSObject>

-(void) horizontalSlidingView:(MHorizontalSlidingView *)slidingView scrollRow:(NSInteger)row currentTable:(UITableView *)tableView;
-(void) horizontalScrollingView:(MHorizontalSlidingView *) slidingView scrollingOff:(NSInteger )row;

-(void) horizontalSlidingView:(MHorizontalSlidingView *)slidingView MJRefresh:(MJRefreshBaseView *)refreshView;

@end

@interface MHorizontalSlidingView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, weak) id tableViewDelegate;
@property (nonatomic, weak) id tableViewDataSource;

@property (nonatomic, assign) BOOL isScroll;

@property (nonatomic, strong) UITableView *currentTable;
@property (nonatomic, assign) float oldOff;

@property (nonatomic, weak) id<MHorizontalSlidingViewDelegate> slidingDelegate;

-(void) setItemsAttribute:(NSInteger)row
SlidingViewDelegate:(id<MHorizontalSlidingViewDelegate>)delegate
      tableDelegate:(id<UITableViewDelegate>)tabDelegate
    tableDataSource:(id<UITableViewDataSource>)tabDataSource;

-(void) reloadSlidingView;

-(void) setScrollPage:(NSInteger )page;

@end
