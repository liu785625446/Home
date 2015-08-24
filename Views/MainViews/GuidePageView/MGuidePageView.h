//
//  BootPageVIew.h
//  Home
//
//  Created by 刘军林 on 14-7-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGuidePageView;

@protocol MGuidePageViewDelegate <NSObject>
-(void) mGuidePageViewComplete:(MGuidePageView *)m_guidePageView;
@end

@interface MGuidePageView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pages;
@property (assign) int currentPage;

@property (nonatomic, strong) UIImageView *backLayerView;
@property (nonatomic, strong) UIImageView *frontLayerView;
@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, weak) id<MGuidePageViewDelegate> delegate;

@end
