//
//  GesturePasswordSettingsViewController.m
//  Home
//
//  Created by 刘军林 on 14-10-15.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "GesturePasswordSettingsViewController.h"
#import "config.h"
#import "Tool.h"

@interface GesturePasswordSettingsViewController ()

@end

@implementation GesturePasswordSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _previousString = [NSString string];
    [self reset];
    // Do any additional setup after loading the view.
}

-(IBAction)popAction:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置手势密码
-(void) reset {
    _gesturePasswordView = [[GesturePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds didStyle:Reset];
    [_gesturePasswordView.tentacleView setResetDelegate:self];
    _gesturePasswordView.tentacleView.style = Reset;
    [_gesturePasswordView.forgetButton setHidden:YES];
    [_gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:_gesturePasswordView];
}

-(BOOL) resetPassword:(NSString *)result
{
    NSLog(@"result:%@",result);
    
    if (result.length < 4) {
        _previousString = @"";
        [_gesturePasswordView.state setTextColor:[UIColor redColor]];
        [_gesturePasswordView.state setText:@"至少连接4个点，请重新输入"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_gesturePasswordView.tentacleView enterArgin];
            });
        });
        return NO;
    }
    
    if ([_previousString isEqualToString:@""]) {
        _previousString = result;
        [_gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [_gesturePasswordView.state setText:@"请验证手势密码"];
        [_gesturePasswordView.tentacleView enterArgin];
    }else {
        
        if ([result isEqualToString:_previousString]) {
            
            [Tool showSuccessHUD:@"设置成功"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[Tool md5:_previousString] forKey:GESTUREPASSWORD];
                [user synchronize];
                sleep(1);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                });
            });
            
        }else {
            _previousString = @"";
            [_gesturePasswordView.state setTextColor:[UIColor redColor]];
            [_gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_gesturePasswordView.tentacleView enterArgin];
                });
            });
            return NO;
        }
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
