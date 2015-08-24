//
//  LoginView.h
//  Home
//
//  Created by 刘军林 on 14-7-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@class MVerificationView;

@protocol MVerificationViewDelegate <NSObject>

-(void) mVerificationViewComplete:(MVerificationView *)verification;

@end

@interface MVerificationView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *boxId;
@property (nonatomic, strong) IBOutlet UITextField *boxPassword;
@property (nonatomic, strong) IBOutlet CustomButton *loginBut;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBInspectable IBOutlet UIButton *autoLogin;

@property (nonatomic, weak) id<MVerificationViewDelegate> delegate;

-(IBAction)loginAction:(id)sender;

@end
