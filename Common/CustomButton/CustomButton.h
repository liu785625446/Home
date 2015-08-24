//
//  CustomButton1.h
//  FIS
//
//  Created by 刘军林 on 14-3-6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (nonatomic, strong) CAShapeLayer* shape;

@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectTitleColor;
@property (nonatomic, strong) UIColor *normalTitleColor;

@end
