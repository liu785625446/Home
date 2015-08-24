//
//  DeviceEditViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-29.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DeviceEditViewController.h"
#import "config.h"
#import "EditDeviceCell.h"
#import "Interface.h"
#import "Tool.h"
#import "EntityRemote.h"
#import "DeviceResource.h"
#import "RemoteTypeViewController.h"
#import "EditRemoteTableViewController.h"
#import "DeviceLinkTableViewController.h"
#import "Toast+UIView.h"
#import "ImageList.h"
#import "EntityRemoteProcess.h"
#import "EntityLineProcess.h"
#import "EntityProcess.h"
#import "EntityLinkProcess.h"
#import "MRoomSelectViewController.h"
#import "MNewRemoteTypeViewController.h"

@interface DeviceEditViewController ()

@end

@implementation DeviceEditViewController

@synthesize entity;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _entityRemoteProcess = [[EntityRemoteProcess alloc] init];
    _entityLineProcess = [[EntityLineProcess alloc] init];
    _entityLinkProcess = [[EntityLinkProcess alloc] init];
    _entityProcess = [[EntityProcess alloc] init];
   
    if ([self.entity.entityType intValue] == AP_TYPE) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
//    boxId = 0f0fa345a018
//    entityID = c8f40203
//    entityName = 新遥控
//    state = 0
//    power = 98
//    link = 0
//    icon = 31
//    entityType = 3
//    delState = 0
//    syncNum = 3
//    switchState = 0
//    entitySignal =  
//    roomId = 1
    self.title = self.entity.entityName;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshAction];
}

-(void) refreshAction
{
    entity = [_entityProcess findEntityForEntity:entity];
    if ([entity.entityType intValue] == REMOTE_INFRARED) {
        
        _remote_list = [[NSMutableArray alloc] initWithCapacity:0];
        _TV_list = [[NSMutableArray alloc] initWithCapacity:0];
        _Air_list = [[NSMutableArray alloc] initWithCapacity:0];
        _custom_list = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *remoteArray = [_entityRemoteProcess findRemoteForEntity:entity];
        for (EntityRemote *remote in remoteArray) {
            if (remote.brandType == 0) {
                [_TV_list addObject:remote];
            }else if (remote.brandType == 1) {
                [_Air_list addObject:remote];
            }else{
                [_custom_list addObject: remote];
            }
        }
        
        if ([_TV_list count] > 0) {
            [_remote_list addObject:_TV_list];
        }
        
        if ([_Air_list count] > 0) {
            [_remote_list addObject:_Air_list];
        }
        
        if ([_custom_list count] > 0) {
            [_remote_list addObject:_custom_list];
        }
    }else if ([entity.entityType intValue] == PANEL_SWITCH_3 || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
        
        _entityLine_list = [[NSMutableArray alloc] initWithCapacity:0];
        _entityLine_list = [_entityLineProcess findEntityLineForEntity:entity];
        _current_entityLine = nil;
    }
    [self.baseTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)deleteEntity:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"确定删除%@设备?",entity.entityName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark -
#pragma mark Action
-(IBAction)saveTitleAction:(id)sender
{
    UIButton *but = (UIButton *)sender;

    if (but.selected) {
        
        [_currentText resignFirstResponder];
        [self.baseTableView setContentOffset:CGPointMake(0, self.baseTableView.contentOffset.y - offsetHeight) animated:YES];
        self.baseTableView.scrollEnabled = YES;
        but.selected = NO;
        if (but == self.lastSaveBut) {
            self.lastSaveBut = nil;
        }
        
        NSString *msg;
        if(([entity.entityType intValue] == PANEL_SWITCH_3 || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) && _current_entityLine) //多路设备路
        {
            _current_entityLine.entityLineName = self.currentText.text;
            
            if ([Tool checkFormatStr:self.currentText.text]) {
                [Tool showMyAlert:S_FORMAT_ERROR];
                return;
            }
            
            msg = [NSString stringWithFormat:@"%@&%@&%@&%d&%@",_current_entityLine.entityID,_current_entityLine.entityLineNum,_current_entityLine.entityLineName,_current_entityLine.icon,entity.roomId];
            
            [_entityProcess editDeviceLineMsg:msg success:^(NSString *code) {
                [self refreshAction];
                [self.baseTableView reloadData];
            } fail:^(NSError *result, NSString *errInfo) {
                
            }];
            
        }else{ //设备编辑
            entity.entityName = self.currentText.text;
            if ([Tool checkFormatStr:self.currentText.text]) {
                [Tool showMyAlert:S_FORMAT_ERROR];
                return;
            }
            msg = [NSString stringWithFormat:@"%@&%d&%@&%d&%@",entity.entityID,0,entity.entityName,entity.icon,entity.roomId];
            
            [_entityProcess editDeviceMsg:msg success:^(NSString *code) {
                [self refreshAction];
                [self.baseTableView reloadData];
            } fail:^(NSError *result, NSString *errInfo) {
                
            }];
        }
    }else{
        self.baseTableView.scrollEnabled = NO;
        DeviceEditTitleCell *cell;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            cell = (DeviceEditTitleCell *)[[but superview] superview];
        }else{
            cell = (DeviceEditTitleCell *)[[[but superview] superview] superview];
        }
        
        [cell.deviceName becomeFirstResponder];
        but.selected = YES;
        self.lastSaveBut = but;
        
        int height = cell.frame.origin.y - self.baseTableView.contentOffset.y;
        CGRect rect = [UIScreen mainScreen].bounds;
        if (rect.size.height - 300 < height) {
            [self.baseTableView setContentOffset:CGPointMake(0, self.baseTableView.contentOffset.y + height + 300 - rect.size.height + 50) animated:YES];
            offsetHeight = height + 300 - rect.size.height + 50;
        }else{
            offsetHeight = 0;
        }
    }
}

-(IBAction)isLinkAction:(id)sender
{
    UISwitch *switchBut = (UISwitch *)sender;
    if ([self checkConnectionStatus]) {
        [switchBut setOn:!switchBut.on animated:YES];
        return;
    }
    
    int state;
    if (switchBut.isOn) {
        state = 0;
    }else{
        state = 1;
    }
    NSString *msg = [NSString stringWithFormat:@"%@&%d",entity.entityID,state];
    
    [[Interface shareInterface:nil] writeFormatDataAction:@"23"
                                                   didMsg:msg
                                              didCallBack:^(NSString *code) {
                                                  NSLog(@"code:%@",code);
                                                  NSArray *entityArray = [code componentsSeparatedByString:@"@"];
                                                  if ([entityArray count] == 11) {
                                                      [_entityProcess addEntityForStr:code];
                                                      entity = [_entityProcess findEntityForEntity:entity];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self.baseTableView reloadData];
                                                      });
                                                  }else{
                                                      [self.view.window makeToast:@"联动开关操作失败"];
                                                      [self.baseTableView reloadData];
                                                  }
                                            }
     ];
}

-(void) resignkeyBoard
{
    [_currentText resignFirstResponder];
    [self.baseTableView setContentOffset:CGPointMake(0, self.baseTableView.contentOffset.y - offsetHeight) animated:YES];
    self.baseTableView.scrollEnabled = YES;
    _lastSaveBut.selected = NO;
    self.lastSaveBut = nil;
    
    NSString *msg;
    if(([entity.entityType intValue] == PANEL_SWITCH_3 || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) && _current_entityLine) //多路设备路
    {
        _current_entityLine.entityLineName = self.currentText.text;
        
        if ([Tool checkFormatStr:self.currentText.text]) {
            [Tool showMyAlert:S_FORMAT_ERROR];
            return;
        }
        msg = [NSString stringWithFormat:@"%@&%@&%@&%d&%d&%@",_current_entityLine.entityID,_current_entityLine.entityLineNum,_current_entityLine.entityLineName,_current_entityLine.icon,_current_entityLine.enabled,entity.roomId];
        
        [_entityProcess editDeviceLineMsg:msg success:^(NSString *code) {
            [self refreshAction];
            [self.baseTableView reloadData];
        } fail:^(NSError *result, NSString *errInfo) {
            
        }];
        
    }else{ //设备编辑
        entity.entityName = self.currentText.text;
        
        if ([Tool checkFormatStr:self.currentText.text]) {
            [Tool showMyAlert:S_FORMAT_ERROR];
            return;
        }
        msg = [NSString stringWithFormat:@"%@&%d&%@&%d&%@",entity.entityID,0,entity.entityName,entity.icon,entity.roomId];
        
        [_entityProcess editDeviceMsg:msg success:^(NSString *code) {
            [self refreshAction];
            [self.baseTableView reloadData];
        } fail:^(NSError *result, NSString *errInfo) {
            
        }];
    }
}

#pragma mark UIAlertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *msg = entity.entityID;
        [Tool showMyHUD:@"删除中"];
        [[Interface shareInterface:nil] writeFormatDataAction:@"16" didMsg:msg didCallBack:^(NSString *code){
            NSArray *tempArray = [code componentsSeparatedByString:@"@"];
            if ([tempArray count] == 2) {
                [_entityProcess removeEntity:entity];
                [Tool showSuccessHUD:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Tool showFailHUD:@"删除失败"];
            }
        }];
    }
}

#pragma mark UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentText = textField;
    DeviceEditTitleCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        cell = (DeviceEditTitleCell *)[[textField superview] superview];
    }else{
        cell = (DeviceEditTitleCell *)[[[textField superview] superview] superview];
    }
    
    NSLog(@"cell:%@,%@",cell.deviceName.text,cell.entity);
    if ([cell.entity isKindOfClass:[EntityLine class]]) {
        _current_entityLine = (EntityLine *)cell.entity;
    }
    cell.updateBut.selected = YES;
    _lastSaveBut = cell.updateBut;
}

#pragma mark SelectImgDelegate
-(void) selectImg:(NSString *)image
{
    NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%@&%@",entity.entityID,_current_entityLine.entityLineNum,_current_entityLine.entityLineName,image,entity.roomId];
    [_entityProcess editDeviceLineMsg:msg success:^(NSString *code) {
        [self refreshAction];
        [self.baseTableView reloadData];
    } fail:^(NSError *result, NSString *errInfo) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == CURTAIN_SWITCH || [entity.entityType intValue] == REMOTE_RF || [entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == INFRARED_PROBE || [entity.entityType intValue] == SMKEN || [entity.entityType intValue] == AP_TYPE) {
        
        return 1;
        
    } else if ([entity.entityType intValue] == REMOTE_INFRARED) {
        
        return 1 + [_remote_list count];
        
    }else if ([entity.entityType intValue] == PANEL_SWITCH_3 || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
        
        return [_entityLine_list count] + 1;
        
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == CURTAIN_SWITCH || [entity.entityType intValue] == REMOTE_RF || [entity.entityType intValue] == AP_TYPE) {
        
        if ([entity.entityType intValue] == AP_TYPE) {
            return 2;
        }
        return 3;
        
    }else if ([entity.entityType intValue] == REMOTE_INFRARED) {
        
        if (section == 0) {
            return 3;
        }else{
            NSArray *temp = [_remote_list objectAtIndex:section-1];
            return [temp count];
        }
        
    }else if ([entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == SMKEN || [entity.entityType intValue] == INFRARED_PROBE || [entity.entityType intValue] == GAS_DETECTION){
        
        if (entity.link) {
            return 4;
        }else{
            return 5;
        }
        
    }else if ([entity.entityType intValue] == PANEL_SWITCH_3 || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
        if (section == 0) {
            return 2;
        }else {
            return 3;
        }
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0f;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([entity.entityType intValue] == REMOTE_INFRARED) {
        
        if (section !=0) {
            
            NSString *name;
            if (section == 1) {
                name = @"电视";
            }else if (section == 2) {
                name = @"空调";
            }else if (section == 3) {
                name = @"自定义";
            }
            
            UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseRect.size.width, 15)];
            vi.backgroundColor = [UIColor clearColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 15)];
            NSArray *array = [_remote_list objectAtIndex:section-1];
            label.text = [NSString stringWithFormat:@"%@ (%d)",name,[array count]];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13.0f];
            [vi addSubview:label];
            
            return vi;
        }
        
    }else if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
        
        if (section != 0) {
            
            NSString *name;
            
            if (section == 1) {
                name = @"设备第一路设置";
            }else if (section == 2) {
                name = @"设备第二路设置";
            }else if (section == 3) {
                name = @"设备第三路设置";
            }
            
            UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseRect.size.width, 15)];
            vi.backgroundColor = [UIColor clearColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 15)];
            label.text = [NSString stringWithFormat:@"%@",name];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13.0f];
            [vi addSubview:label];
            
            return vi;
        }
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == CURTAIN_SWITCH || [entity.entityType intValue] == REMOTE_RF || [entity.entityType intValue] == AP_TYPE) {
        
        if (indexPath.row == 0) {
            
            DeviceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceImg"
                                                                  forIndexPath:indexPath];
            [cell setEntity:entity];

            if ([entity.entityType intValue] == AP_TYPE) {
                [cell.deviceImg setImage:[UIImage imageNamed:@"icon_ap.png"]];
                [cell.deviceName setText:@"智能AP"];
            }
            
            return cell;
        }else if(indexPath.row == 1){
            
            DeviceEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceEditTitle"
                                                                        forIndexPath:indexPath];
            [cell setEntity:entity];
            cell.deviceName.delegate = self;
            cell.deviceName.inputAccessoryView = toolbar;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomsIdentifier" forIndexPath:indexPath];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = @"选择房间";
            return cell;
        }
        
    }else if ([entity.entityType intValue] == REMOTE_INFRARED) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                DeviceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceImg"
                                                                      forIndexPath:indexPath];
                [cell setEntity:entity];
                
                return cell;
            }else if(indexPath.row == 1){
                
                DeviceEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceEditTitle"
                                                                            forIndexPath:indexPath];
                [cell setEntity:entity];
                cell.deviceName.delegate = self;
                cell.deviceName.inputAccessoryView = toolbar;
                return cell;
            }else if(indexPath.row == 2){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddEntityRemoteCell" forIndexPath:indexPath];
                return cell;
            }else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomsIdentifier" forIndexPath:indexPath];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.textLabel.text = @"选择房间";
                return cell;
            }
            
        }else{
            
            NSArray *temp = [_remote_list objectAtIndex:indexPath.section-1];
            EntityRemote *entityRemote = [temp objectAtIndex:indexPath.row];
            RemoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemoteCell"
                                                               forIndexPath:indexPath];
            [cell setEntityRemote:entityRemote];
            return cell;
        }
    }else if ([entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == SMKEN || [entity.entityType intValue] == INFRARED_PROBE){
        
        if (indexPath.row == 0) {
            
            DeviceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceImg"
                                                                  forIndexPath:indexPath];
            [cell setEntity:entity];
            return cell;
        }else if(indexPath.row == 1){
            
            DeviceEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceEditTitle"
                                                                        forIndexPath:indexPath];
            [cell setEntity:entity];
            cell.deviceName.delegate = self;
            cell.deviceName.inputAccessoryView = toolbar;
            return cell;
        }else if (indexPath.row == 2) {
            
            StartLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartLink" forIndexPath:indexPath];
            [cell setEntity:entity];
            return cell;
            
        }else if(indexPath.row == 3){
            
            if (entity.link) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomsIdentifier" forIndexPath:indexPath];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.textLabel.text = @"选择房间";
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"linkDevice"];
                cell.frame = CGRectMake(0, 0, self.baseRect.size.width, 60);
                cell.textLabel.font = [UIFont systemFontOfSize:17.0];
                cell.textLabel.text = @"联动管理";
                //            [NSString stringWithFormat:@"联动管理(已关联%d个设备)",[[_entityLinkProcess findEntityLinkForEntity:entity] count]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomsIdentifier" forIndexPath:indexPath];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.textLabel.text = @"选择房间";
            return cell;
        }
    }else if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                DeviceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceImg"
                                                                      forIndexPath:indexPath];
                [cell setEntity:entity];
                return cell;
            }else{
                
                DeviceEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceEditTitle"
                                                                            forIndexPath:indexPath];
                [cell setEntity:entity];
                cell.deviceName.delegate = self;
                cell.deviceName.inputAccessoryView = toolbar;
                return cell;
            }
        }else {
            
            EntityLine *entityline = [_entityLine_list objectAtIndex:indexPath.section - 1];
            
            if (indexPath.row == 0) {
                
                DeviceEditImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceEditImg" forIndexPath:indexPath];
                [cell setEntityLine:entityline];
                return cell;
                
            }else if(indexPath.row == 1){
                
                DeviceEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceEditTitle"
                                                                            forIndexPath:indexPath];
                [cell setEntity:entityline];
                cell.deviceName.delegate = self;
                cell.deviceName.inputAccessoryView = toolbar;
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomsIdentifier" forIndexPath:indexPath];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.textLabel.text = @"选择房间";
                return cell;
            }
        }
    }
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([self checkConnectionStatus]) {
        return;
    }
    if ([entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == CURTAIN_SWITCH || [entity.entityType intValue] == REMOTE_RF || [entity.entityType intValue] == AP_TYPE) {
        
        if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"RoomsIdentifier" sender:nil];
        }
        
    }else if ([entity.entityType intValue] == REMOTE_INFRARED) {
        
        if (indexPath.row == 2 && indexPath.section == 0) {
            
            [self performSegueWithIdentifier:@"RemoteType" sender:nil];
//            [self performSegueWithIdentifier:@"MNewRemoteTypeIdentifier" sender:nil];
        }else if (indexPath.row == 3) {
            [self performSegueWithIdentifier:@"RoomsIdentifier" sender:nil];
        }else if (indexPath.section > 0) {
            NSArray *temp = [_remote_list objectAtIndex:indexPath.section - 1];
            _currentRemote = [temp objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"EditRemote" sender:nil];
        }
        
    }else if ([entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == SMKEN || [entity.entityType intValue] == INFRARED_PROBE || [entity.entityType intValue] == GAS_DETECTION){
        
        if (entity.link) {
            if (indexPath.row == 3) {
                [self performSegueWithIdentifier:@"RoomsIdentifier" sender:nil];
            }
        }else{
            if (indexPath.row == 3) {
                [self performSegueWithIdentifier:@"DeviceLink" sender:nil];
                [self.baseTableView reloadData];
            }else if(indexPath.row == 4){
                [self performSegueWithIdentifier:@"RoomsIdentifier" sender:nil];
            }
        }
        
    }else if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
        if (indexPath.section > 0 && indexPath.row == 0) {
//            [self performSegueWithIdentifier:@"SelectImg" sender:nil];
//            _current_entityLine = [_entityLine_list objectAtIndex:indexPath.section - 1];
        }else if (indexPath.section > 0 && indexPath.row == 2)
        {
            _current_entityLine = [_entityLine_list objectAtIndex:indexPath.section - 1];
            [self performSegueWithIdentifier:@"RoomsIdentifier" sender:nil];
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.lastSaveBut) {
        [self saveTitleAction:self.lastSaveBut];
    }
    if ([segue.identifier isEqualToString:@"RemoteType"]) {
        
        RemoteTypeViewController *remoteType = segue.destinationViewController;
        remoteType.entity_id = entity.entityID;
        remoteType.deviceManageDelegate = _deviceManageDelegate;
        remoteType.deviceEditDelegate = self;
        
    }else if ([segue.identifier isEqualToString:@"MNewRemoteTypeIdentifier"]) {
        MNewRemoteTypeViewController *remoteType = segue.destinationViewController;
        remoteType.entityId = entity.entityID;
    }
    else if ([segue.identifier isEqualToString:@"EditRemote"]) {
        
        EditRemoteTableViewController *editRemote = segue.destinationViewController;
        editRemote.entityRemote = _currentRemote;
        
    }else if ([segue.identifier isEqualToString:@"DeviceLink"]) {
        
        DeviceLinkTableViewController *deviceLink = segue.destinationViewController;
        deviceLink.linkEntity = entity;
        
    }else if ([segue.identifier isEqualToString:@"SelectImg"]) {
        
        UINavigationController *nav = segue.destinationViewController;
        SelectImgViewController *selectImg = [[nav viewControllers] objectAtIndex:0];
        selectImg.delegate = self;
        if ([entity.entityType intValue] == PANEL_SWITCH_2) {
            selectImg.type = _SWITCHICON2;
        }else if ([entity.entityType intValue] == PANEL_SWITCH_3)  {
            selectImg.type = _SWITCHICON3;
        }else if ([entity.entityType intValue] == PANEL_SWITCH_1) {
            selectImg.type = _SWITCHICON1;
        }
        
    }else if ([segue.identifier isEqualToString:@"RoomsIdentifier"]) {
        UINavigationController *nav = segue.destinationViewController;
        MRoomSelectViewController *roomSelect = [[nav viewControllers] objectAtIndex:0];
//        roomSelect.entity = self.entity;
        if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
            roomSelect.baseModel = _current_entityLine;
        }else{
            roomSelect.baseModel = self.entity;
        }
    }
}

@end
