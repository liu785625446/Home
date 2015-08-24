//
//  CustomButton.h
//  Home
//
//  Created by 刘军林 on 14-1-9.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionUpLeft = 1,
    DirectionRight,
    DirectionTop,
    DirectionBottom,
    DirectionNone
};

@class DirectionButton;

@protocol CustomButtonDelegate <NSObject>

-(void)directionDown:(DirectionButton*)but didMsg:(NSString *)msg;

@end



@interface  DirectionButton: UIView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <CustomButtonDelegate> delegate;

@property (nonatomic, assign) BOOL isLongPress;

@end
