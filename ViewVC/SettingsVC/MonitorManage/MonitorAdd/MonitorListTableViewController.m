//
//  MonitorListTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MonitorListTableViewController.h"
#import "Interface.h"
#import "MonitorCell.h"
#import "Tool.h"
#import "Camerainfos.h"
#import "CamerainfosProcess.h"

@interface MonitorListTableViewController ()

@end

@implementation MonitorListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _camerainfosProcess = [[CamerainfosProcess alloc] init];
    [self searchMonitorList];
}

-(void) searchMonitorList
{
    [Tool showMyHUD:@"加载中"];
    [[Interface shareInterface:nil] writeFormatDataAction:@"21"
                                                   didMsg:@""
                                              didCallBack:^(NSString *code){
        
                                                  NSLog(@"code:%@",code);
                                                  
                                                  [Tool showSuccessHUD:@"加载成功"];
                                                  NSArray *array = [code componentsSeparatedByString:@","];
                                                  _monitorList = [[NSMutableArray alloc] initWithCapacity:0];
                                                  for (NSString *str in array) {
                                                      if ([str length] > 0) {
                                                          [_monitorList addObject:str];
                                                      }
                                                  }
                                                  [self.baseTableView reloadData];
                                              }
     ];
    _bindMonitorList = [_camerainfosProcess findAllCameraInfos];
}

#pragma mark -
#pragma mark MonitorCellDelegate
-(void) monitorBindWithIndex:(int)index
{
    if ([self checkConnectionStatus]) {
        return;
    }
    if (index == 9999) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"摄像头已绑定!"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        _monitorNum = [_monitorList objectAtIndex:index];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确定绑定新摄像头%@",_monitorNum]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.text = [NSString stringWithFormat:@"新摄像头%@",_monitorNum];
        [alert show];
    }
//    NSString *msg = [NSString stringWithFormat:@"-1&%@&1&"]
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex != 0) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        
        if ([Tool checkFormatStr:tf.text]) {
            [Tool showMyAlert:S_FORMAT_ERROR];
            return;
        }
        
        NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%@",BOX_ID_VALUE, _monitorNum, tf.text, @"1"];
        
        [Tool showMyHUD:@"绑定中"];
        [[Interface shareInterface:nil] writeFormatDataAction:@"20"
                                                       didMsg:msg
                                                  didCallBack:^(NSString *code) {
                                                      
                                                      NSLog(@"code:%@",code);
                                                      NSArray *array = [code componentsSeparatedByString:@"@"];
                                                      if ([array count] > 1) {
                                                          [_camerainfosProcess synchronousCamerainfos:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  _bindMonitorList = [_camerainfosProcess findAllCameraInfos];
                                                                  [Tool showSuccessHUD:@"绑定成功"];
                                                                  [self.baseTableView reloadData];
                                                              });
                                                          }didFail:^{
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  _bindMonitorList = [_camerainfosProcess findAllCameraInfos];
                                                                  [Tool showSuccessHUD:@"绑定成功"];
                                                                  [self.baseTableView reloadData];
                                                              });
                                                             
                                                          }];
                                                      }else{
                                                          [Tool showFailHUD:@"绑定失败"];
                                                      }
                                                  }
         ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_monitorList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell" forIndexPath:indexPath];
    
    cell.monitorBindBut.tag = indexPath.row;
    
    if ([self iskindOfObj:[_monitorList objectAtIndex:indexPath.row]]) {
//        cell.monitorBindBut.enabled = NO;
        cell.monitorBindBut.tag = 9999;
        cell.delegate = self;
        cell.bangding.hidden = NO;
        cell.monitorImg.layer.cornerRadius = cell.monitorImg.frame.size.width/2;
        [cell.monitorBindBut setImage:[UIImage imageNamed:@"button_bangding_org.png"] forState:UIControlStateNormal];
    }else{
        cell.delegate = self;
        cell.bangding.hidden = YES;
        cell.monitorImg.layer.cornerRadius = cell.monitorImg.frame.size.width/2;
        [cell.monitorBindBut setImage:[UIImage imageNamed:@"button_bangding.png"] forState:UIControlStateNormal];
    }
    
    [cell setName:[_monitorList objectAtIndex:indexPath.row]];
    return cell;
}

-(BOOL) iskindOfObj:(NSString *)name
{
    for (Camerainfos *camerainfo in _bindMonitorList) {
        if ([camerainfo.cameraNum isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

@end
