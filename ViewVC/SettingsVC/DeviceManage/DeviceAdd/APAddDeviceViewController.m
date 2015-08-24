//
//  APAddDeviceViewController.m
//  Home
//
//  Created by 刘军林 on 15/6/26.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "APAddDeviceViewController.h"
#import "APAddDeviceCell.h"
#import "Entity.h"
#import "AddDeviceStep1ViewController.h"

@interface APAddDeviceViewController ()

@end

@implementation APAddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_apList count] + 1;
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

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APAddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.name.text = @"主机";
        cell.info.text = @"主机";
        cell.img.image = [UIImage imageNamed:@"icon_mrjbox_.png"];
    }else{
        Entity *entity = [_apList objectAtIndex:indexPath.row - 1];
        
        cell.name.text = entity.entityName;
        cell.info.text = entity.entityName;
        cell.img.image = [UIImage imageNamed:@"icon_ap.png"];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Step" sender:[NSNumber numberWithInt:0]];
    }else{
        Entity *entity = [_apList objectAtIndex:indexPath.row - 1];
        [self performSegueWithIdentifier:@"Step" sender:entity.entityID];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddDeviceStep1ViewController *addDevice = segue.destinationViewController;
    addDevice.deviceType = _deviceType;
    addDevice.settingDelegate = _settingDelegate;
    if ([sender isKindOfClass:[NSNumber class]]) {
        addDevice.entityType = [NSString stringWithFormat:@"%d",0];
    }else{
        addDevice.entityType = (NSString *)sender;
    }
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
