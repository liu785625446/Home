//
//  MonitorSettingsViewController.m
//  Home
//
//  Created by 刘军林 on 14-9-24.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MonitorSettingsViewController.h"
#import "Interface.h"
#import "Tool.h"
#import "Toast+UIView.h"
#import "MonitorEidtCell.h"
#import "CamerainfosProcess.h"
#import "PPPPChannelManagement.h"
#import "cmdhead.h"
#import "obj_common.h"
#import "APICommon.h"
#import "PPPPDefine.h"
#import "MonitorVideo.h"
#import "MRoomSelectViewController.h"
#import "WFSearchResult.h"

@interface MonitorSettingsViewController ()

@property  CPPPPChannelManagement* m_PPPPChannelMgt;
@property MonitorVideo *monitor;

@end

@implementation MonitorSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wifi_list = [[NSMutableArray alloc] initWithCapacity:0];
    _camerainfosProcess = [[CamerainfosProcess alloc] init];
    _current_wifi_ssid = @"";
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _camerainfo = [_camerainfosProcess findCameraInfosForId:_camerainfo.cameraNum];
}

-(void) viewDidAppear :(BOOL)animated
{
    [super viewDidAppear:animated];
    _monitor = [MonitorVideo shareMonitorVideo];
    _monitor.delegate = self;
    NSString *status = [_monitor.p2p_MonitorStatus objectForKey:_camerainfo.cameraNum];
    if ([status isEqualToString:STATUS_CONNECTING_TEXT]) {
        [Tool showMyHUD:@"连接中..."];
    }else if ([status isEqualToString:STATUS_CONNECTING_SUCCESS]){
        [Tool showMyHUD:@"连接中..."];
        [_monitor startCurrentWifiSearch:_camerainfo.cameraNum];
    }else{
        [self.baseTableView.window makeToast:status];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) connectStatusChange:(NSString *)statusStr didSSID:(NSString *)ssid
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([ssid isEqualToString:_camerainfo.cameraNum]) {
            if ([statusStr isEqualToString:STATUS_CONNECTING_TEXT]) {
                [self.view makeToast:@"连接超时"];
            }else if ([statusStr isEqualToString:STATUS_CONNECTING_SUCCESS]){
                [Tool showMyHUD:@"连接中..."];
                [_monitor startCurrentWifiSearch:_camerainfo.cameraNum];
            }else{
                [Tool hideMyHUD];
                [self.view makeToast:statusStr];
            }
        }
    });
}

-(void) connectCurrentWifi
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _current_wifi_ssid = _monitor.current_wifi;
        _isContentP2P = YES;
        [Tool showSuccessHUD:@"连接成功"];
        [self.baseTableView reloadData];
    });
}

-(void) connectWifiList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _wifi_list = _monitor.wifi_list;
        [Tool showSuccessHUD:@"连接成功"];
        [self.baseTableView reloadData];
    });
}

#pragma action
-(IBAction)deleteMonitorAction:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    
    [Tool showMyHUD:@"删除中"];
    NSString *msg = [NSString stringWithFormat:@"%@&%@",BOX_ID_VALUE,_camerainfo.cameraNum];
    [[Interface shareInterface:nil] writeFormatDataAction:@"25"
                                                   didMsg:msg
                                              didCallBack:^(NSString *code){
                                                  NSLog(@"code:%@",code);
                                                  NSArray *tempArray = [code componentsSeparatedByString:@","];
                                                  if ([tempArray count] >= 2) {
                                                      [_camerainfosProcess synchronousCamerainfos:^{
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [Tool showSuccessHUD:@"删除成功"];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          });
                                                      }didFail:^{
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [Tool showSuccessHUD:@"删除成功"];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          });
                                                      }];
                                                  }else{
                                                      [Tool showFailHUD:@"删除失败"];
                                                  }
                                              }
     ];
}

-(IBAction)switchWifiAction:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    UISwitch *switchBut = (UISwitch *)sender;
    _isWifi = switchBut.isOn;
    
    if(_isWifi){
        [Tool showMyHUD:@"wifi搜索中..."];
        [_monitor startWifiListSearch:_camerainfo.cameraNum];
    }else{
        [self.baseTableView reloadData];
    }
}

-(IBAction)saveTitleAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    if (but.selected) {
        
        [_currentText resignFirstResponder];
        but.selected = NO;
        
        if ([Tool checkFormatStr:_currentText.text]) {
            [Tool showMyAlert:S_FORMAT_ERROR];
            return;
        }
        
        NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%@",BOX_ID_VALUE, _camerainfo.cameraNum,_currentText.text,_camerainfo.roomId];
        
        [[Interface shareInterface:nil] writeFormatDataAction:@"20"
                                                       didMsg:msg
                                                  didCallBack:^(NSString *code){
                                                      
                                                      NSLog(@"code:%@",code);
                                                      NSArray *array = [code componentsSeparatedByString:@"@"];
                                                      if ([array count] >= 2) {
                                                          [_camerainfosProcess synchronousCamerainfos:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self.view.window makeToast:@"操作成功!"];
                                                                  _camerainfo.cameraName = _currentText.text;
                                                              });
                                                          }didFail:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self.view.window makeToast:@"操作成功!"];
                                                              });
                                                          }];

                                                      }else{
                                                          [self.view.window makeToast:@"操作失败!"];
                                                          _currentText.text = _camerainfo.cameraName;
                                                      }
                                                }
         ];
    }else {
        MonitorNameCell *cell;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            cell = (MonitorNameCell *)[[but superview] superview];
        }else{
            cell = (MonitorNameCell *)[[[but superview] superview] superview];
        }
        
        but.selected = YES;
        [cell.monitorName becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        UITextField *tt = [alertView textFieldAtIndex:0];
        if ([tt.text length] >= 8) {
            
            NSString *msg = [NSString stringWithFormat:@"%@&%@&%@",_camerainfo.cameraNum,alertView.title,tt.text];
            NSLog(@"msg:%@",msg);
            
            if ([Tool checkFormatStr:tt.text]) {
                [Tool showMyAlert:S_FORMAT_ERROR];
                return;
            }
//            [_monitor setWifi:_camerainfo.cameraNum didWifi:alertView.title didPwd:tt.text];
            [_monitor setWifi:_currentWF didWifi:alertView.title didPwd:tt.text];
            _current_wifi_ssid = alertView.title;
//            [_monitor rebootDeviceCamersId:_camerainfo.cameraNum];
            [self.baseTableView reloadData];
        }else{
            [Tool showMyAlert:@"WIFI密码错误"];
        }
    }
}

-(void) resignkeyBoard
{
    MonitorNameCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        cell = (MonitorNameCell *)[[_currentText superview] superview];
    }else{
        cell = (MonitorNameCell *)[[[_currentText superview] superview] superview];
    }
    [self saveTitleAction:cell.monitorEdit];
}

#pragma mark -
#pragma mark UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    _currentText = textField;
    MonitorNameCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        cell = (MonitorNameCell *)[[textField superview] superview];
    }else{
        cell = (MonitorNameCell *)[[[textField superview] superview] superview];
    }
    
    cell.monitorEdit.selected = YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isContentP2P) {
        return 1;
    }
    return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else{
        if (_isWifi) {
            if ([_wifi_list count] == 0) {
                return 2;
            }else{
                return [_wifi_list count];
            }
        }else{
            if ([_camerainfo.wifiName length] > 0) {
                return 2;
            }else{
                return 1;
            }
        }
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 10.0f;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"sectionttt:%d",section);
    if (section == 1) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.frame.size.width - 20, 20)];
        label.text = [_monitor.p2p_MonitorStatus objectForKey:_camerainfo.cameraNum];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor grayColor];
        [headerView addSubview:label];
//        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }else{
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MonitorNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorName" forIndexPath:indexPath];
        cell.monitorName.text = _camerainfo.cameraName;
        cell.monitorName.delegate = self;
        [cell.monitorEdit setImage:[UIImage imageNamed:@"icon_editorsave.png"]
                          forState:UIControlStateSelected];
        cell.monitorName.inputAccessoryView = toolbar;
        
        return cell;
    }else if (indexPath.section == 1) {
        
        MonitorQualityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorQuality" forIndexPath:indexPath];
        cell.name.text = @"选择房间";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    
    }else {
        
        if (_isWifi && [_wifi_list count] > 0) {
            if (indexPath.row == 0) {
                MonitorWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorWifi" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WIFI"];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                WFSearchResult *searchResult = [_wifi_list objectAtIndex:indexPath.row-1];
                cell.textLabel.text = searchResult.strSSID;
                if ([_current_wifi_ssid isEqualToString:cell.textLabel.text]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
            }
        }else {
//            if ([_current_wifi_ssid length] > 0) {
                if (indexPath.row == 0) {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WIFI"];
                    cell.textLabel.text = [NSString stringWithFormat:@"当前链接WIFI：%@",_current_wifi_ssid];
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                    MonitorWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorWifi" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    _wifiSwitch = cell.monitorSwitch;
                    return cell;
                }
//            }else{
//                MonitorWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorWifi" forIndexPath:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//            }
        }
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([self checkConnectionStatus]) {
        return;
    }
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"RoomIdentifier" sender:nil];
    }else if (indexPath.section == 2) {
        
        if (_isWifi) {
            int index = 0;
            if ([_wifi_list count] == 0) {
                index = index + 1;
            }
            if (indexPath.row > index) {
                _currentWF = [_wifi_list objectAtIndex:indexPath.row - 1];
                NSString *wifi = _currentWF.strSSID;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:wifi message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                UITextField *tf = [alert textFieldAtIndex:0];
                tf.placeholder = @"请输入WIFI密码";
                [alert show];
            }
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RoomIdentifier"]) {
        UINavigationController *nav = segue.destinationViewController;
        MRoomSelectViewController *room = [nav.viewControllers objectAtIndex:0];
        room.baseModel = _camerainfo;
    }
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
