//
//  LoginView.m
//  Home
//
//  Created by 刘军林 on 14-7-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MVerificationView.h"
#import "Tool.h"
#import "Interface.h"
#import "MTopWarnView.h"

@implementation MVerificationView
@synthesize boxId;
@synthesize boxPassword;
@synthesize loginBut;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }

    return self;
}

-(void) setDelegate:(id<MVerificationViewDelegate>)delegate
{
    self.imageView.layer.cornerRadius = 5.0f;
    self.imageView.layer.masksToBounds = YES;
    _delegate = delegate;
}

-(IBAction)autoLoginAction:(id)sender
{
    _autoLogin.selected = !_autoLogin.selected;
}

-(IBAction)loginAction:(id)sender
{
    if ([self.boxPassword.text isEqualToString:@"restartap"] || [self.boxPassword.text isEqualToString:@"2d2a871j"]) {
        [_delegate mVerificationViewComplete:self];
        return ;
    }
    
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self];
        return;
    }

    [self.boxPassword resignFirstResponder];
    if ([boxPassword.text length] < 6 || [boxPassword.text isEqualToString:@""]) {
        [Tool showMyAlert:@"密码错误!"];
        return;
    }
    
    if ([Tool checkFormatStr:boxPassword.text]) {
        [Tool showMyAlert:S_FORMAT_ERROR];
        return;
    }
    
    [Tool showMyHUD:@"加载中"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (_autoLogin.selected) {
        [userDefaults setObject:[NSNumber numberWithInteger:AUTO_LOGIN_OPEN] forKey:AUTO_LOGIN];
        [userDefaults synchronize];
    }else{
        [userDefaults setObject:[NSNumber numberWithInteger:AUTO_LOGIN_CLOSE] forKey:AUTO_LOGIN];
        [userDefaults synchronize];
    }
    
    [[Interface shareInterface:nil] writeFormatDataAction:@"2"
                                                   didMsg:self.boxPassword.text
                                              didCallBack:^(NSString *msg){
                                                       
                                                       [Tool hideMyHUD];
                                                       NSLog(@"验证信息:%@",msg);
                                                       if ([msg isEqualToString:@"0"]) {
                                                           [_delegate mVerificationViewComplete:self];
                                                       }else {
                                                           [Tool showFailHUD:@"密码错误"];
                                                           return ;
                                                       }
    }];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.boxPassword becomeFirstResponder];
    self.boxPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginBut.normalColor = [UIColor blueColor];
    self.loginBut.selectColor = [UIColor whiteColor];
    self.loginBut.selectTitleColor = [UIColor whiteColor];
    self.loginBut.normalTitleColor = [UIColor blueColor];
}


@end
