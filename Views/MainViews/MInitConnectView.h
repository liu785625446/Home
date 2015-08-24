//
//  LoadConnectView.h
//  Home
//
//  Created by 刘军林 on 14-7-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MInitConnectView;
@protocol MInitConnectViewDelegate <NSObject>

-(void) mInitContentComplete:(MInitConnectView *)connectView;

@end

@interface MInitConnectView : UIView

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, weak) id<MInitConnectViewDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *connectStatus;

-(void) removeInitConnectView;
@end
