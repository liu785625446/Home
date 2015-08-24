//
//  SettingsViewController.m
//  Home
//
//  Created by 刘军林 on 14-1-21.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "Interface.h"
#import "AddDeviceViewController.h"
#import "Tool.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *master = [user objectForKey:MASTER];
    
    if ([master isEqualToString:@"0"]) {
        array = @[@[@"房间管理"],
                  @[@"新增设备",@"设备管理"],
                  @[@"新增摄像头",@"摄像头管理"],
                  @[@"新增情景",@"情景管理"],
                  @[@"短信接收",@"手势密码",@"遥控声音设置"]
                ];
        imgArray = @[@[@"seticon_roommanage.png"],
                     @[@"seticon_shebeiadd.png",@"seticon_shebeimanage.png"],
                     @[@"seticon_cameraadd.png",@"seticon_cameramanage.png"],
                     @[@"seticon_qjadd.png",@"seticon_qjmanage.png"],
                     @[@"seticon_message.png",@"seticon_handlogin.png",@"seticon_zhendong.png"]
                    ];
    }else{
        array = @[@[@"手势密码",@"遥控声音设置"]];
        imgArray = @[@[@"seticon_handlogin.png",@"seticon_zhendong.png"]];
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
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tempArray = [array objectAtIndex:section];
    return [tempArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    NSArray *tempArray = [array objectAtIndex:indexPath.section];
    cell.title.text = [tempArray objectAtIndex:indexPath.row];
    cell.title.font = [UIFont systemFontOfSize:15.0f];
    
    NSArray *tempImgArr = [imgArray objectAtIndex:indexPath.section];
    cell.img.image = [UIImage imageNamed:[tempImgArr objectAtIndex:indexPath.row]];
    
    if ([cell.title.text isEqualToString:@"遥控声音设置"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.switchBut.hidden = NO;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:SHOCK]) {
            [cell.switchBut setOn:YES animated:YES];
        }else {
            [cell.switchBut setOn:NO animated:YES];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.switchBut.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.0f;
    }
    return 10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *master = [user objectForKey:MASTER];
    
    if ([master isEqualToString:@"0"]) {
        
        if (indexPath.section == 0) {
            [self performSegueWithIdentifier:@"roomsIdentifier" sender:nil];
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"AddDevice" sender:nil];
            }else {
                [self performSegueWithIdentifier:@"DeviceManage" sender:nil];
            }
            
        }else if (indexPath.section == 2){
            
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"AddMonitor" sender:nil];
            }else{
                [self performSegueWithIdentifier:@"MonitorManage" sender:nil];
            }
            
        }else if (indexPath.section == 3) {
            
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"AddSence" sender:nil];
            }else {
                [self performSegueWithIdentifier:@"SenceList" sender:nil];
            }
            
        }else if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"ContactPeople" sender:nil];
            }else if(indexPath.row == 1){
                [self performSegueWithIdentifier:@"GesturePassword" sender:nil];
            }
        }
    }else {
        [self performSegueWithIdentifier:@"GesturePassword" sender:nil];
    }
}

-(IBAction)soundSwitch:(id)sender
{
    UISwitch *switchBut = (UISwitch *)sender;
    if (switchBut.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:SHOCK forKey:SHOCK];
    }else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHOCK];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddDevice"]) {
        AddDeviceViewController *addDevice = segue.destinationViewController;
        addDevice.settingsDelegate = self;
    }
}

@end
