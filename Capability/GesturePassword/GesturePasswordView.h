//
//  GesturePasswordView.h
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@protocol GesturePasswordDelegate <NSObject>

-(void) forget;
-(void) change;

@end

@interface GesturePasswordView : UIView <TouchBeginDelegate>

-(id) initWithFrame:(CGRect)frame didStyle:(GestureStyle)style;

@property (nonatomic, strong) TentacleView *tentacleView;

@property (nonatomic, strong) UILabel *state;

@property (nonatomic, assign) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIButton *changeButton;

@end
