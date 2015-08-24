//
//  TentacleView.h
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Verify = 0,  //验证
    Reset,       //设置
    Update,      //修改
} GestureStyle;

@protocol ResetDelegate <NSObject>

-(BOOL) resetPassword:(NSString *)result;

@end

@protocol VerificationDelegate <NSObject>

-(BOOL) verification:(NSString *)result;

@end

@protocol TouchBeginDelegate <NSObject>

-(void) gestureTouchBegin;

@end


@interface TentacleView : UIView

@property (nonatomic, strong) NSArray *buttonArray;

@property (nonatomic, assign) id<VerificationDelegate> rerificationDelegate;

@property (nonatomic, assign) id<ResetDelegate> resetDelegate;

@property (nonatomic, assign) id<TouchBeginDelegate> touchBeginDelegate;

@property (nonatomic, assign) GestureStyle style;

-(void) enterArgin;

@end
