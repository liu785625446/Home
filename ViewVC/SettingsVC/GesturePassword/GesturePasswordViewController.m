//
//  GesturePasswordViewController.m
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "GesturePasswordViewController.h"
#import "GesturePasswordCell.h"
#import "config.h"
#import "GesturePasswordSettingsViewController.h"
#import "Tool.h"
#import "Interface.h"

typedef enum : NSUInteger {
    Settings = 0,
    update,
} ResetStyle;

@interface GesturePasswordViewController ()

@end

@implementation GesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:GESTUREPASSWORD]) {
        _isGesturePassword = YES;
    }else{
        _isGesturePassword = NO;
    }
    [self.baseTableView reloadData];
}

-(void)gestureSwitch:(id)sender
{
    UISwitch *switchBut = (UISwitch *)sender;
    if ([self checkConnectionStatus]) {
        [_current_switch setOn:!switchBut.on animated:YES];
        return;
    }
    
    _current_switch = switchBut;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mr.j电视盒子" message:@"请输入盒子密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = Settings;
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"登入密码";
    [alert show];
}

#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        
        if ([tf.text length] < 6) {
            [Tool showMyAlert:@"密码错误!"];
            [self.baseTableView reloadData];
            return;
        }
        
        if ([Tool checkFormatStr:tf.text]) {
            [Tool showMyAlert:S_FORMAT_ERROR];
            return;
        }
        
        [Tool showMyHUD:@"加载中"];
        [[Interface shareInterface:nil] writeFormatDataAction:@"2" didMsg:tf.text didCallBack:^(NSString *code){
            [Tool hideMyHUD];
            
            if ([code isEqualToString:@"0"]) {
                
                if (alertView.tag == Settings) {
                    if (_current_switch.isOn) {
                        [self performSegueWithIdentifier:@"GestureSettings" sender:nil];
                    }else{
                        _isGesturePassword = _current_switch.isOn;
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user removeObjectForKey:GESTUREPASSWORD];
                        [user synchronize];
                        [self.baseTableView reloadData];
                    }
                }else {
                    [self performSegueWithIdentifier:@"GestureSettings" sender:nil];
                }

            }else{
                [Tool showMyAlert:@"密码错误!"];
                [self.baseTableView reloadData];
            }
        }];
    }else {
        [_current_switch setOn:NO animated:YES];
    }
}

-(void)p_autoLoginAction:(id)sender
{
    UISwitch *but = (UISwitch *)sender;
//    but.on = !but.on;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (but.on) {
        [userDefaults setObject:[NSNumber numberWithInteger:AUTO_LOGIN_OPEN] forKey:AUTO_LOGIN];
    }else {
        [userDefaults setObject:[NSNumber numberWithInteger:AUTO_LOGIN_CLOSE] forKey:AUTO_LOGIN];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isGesturePassword) {
        return 3;
    }else {
        return 2;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GesturePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GesturePassword" forIndexPath:indexPath];
        cell.title.text = @"手势密码";
        [cell.switchBut addTarget:self action:@selector(gestureSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.switchBut setOn:_isGesturePassword];
        _current_switch = cell.switchBut;
        return cell;
    }else if (indexPath.row == 1) {
        GesturePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GesturePassword" forIndexPath:indexPath];
        cell.title.text = @"自动登录";
        [cell.switchBut addTarget:self action:@selector(p_autoLoginAction:) forControlEvents:UIControlEventValueChanged];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([[userDefault objectForKey:AUTO_LOGIN] integerValue] == AUTO_LOGIN_OPEN) {
            [cell.switchBut setOn:YES];
        }else{
            [cell.switchBut setOn:NO];
        }
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        
        if ([self checkConnectionStatus]) {
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mr.j电视盒子" message:@"请输入盒子密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = Update;
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.placeholder = @"登入密码";
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
