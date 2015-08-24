//
//  DeviceLinkTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DeviceLinkTableViewController.h"
#import "Interface.h"
#import "config.h"
#import "DeviceLinkCell.h"
#import "EntityLink.h"
#import "Toast+UIView.h"
#import "Tool.h"
#import "EntityLine.h"
#import "EntityDao.h"
#import "EntityLinkDao.h"
#import "EntityLinkProcess.h"
#import "EntityProcess.h"

@interface DeviceLinkTableViewController ()

@end

@implementation DeviceLinkTableViewController
@synthesize entity_list;
@synthesize entityLink_list;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _entityLinkProcess = [[EntityLinkProcess alloc] init];
    _entityProcess = [[EntityProcess alloc] init];
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
    [self refreshAction];
}

-(void) refreshAction
{
//    查询本地联动设备
    self.entity_list = [_entityProcess findIsLinkEntity];
    self.entityLink_list = [_entityLinkProcess findEntityLinkForEntity:_linkEntity];
//    更新服务器联动设备
    [self.baseTableView reloadData];
    
//    同步服务器数据
    [_entityLinkProcess synchronousEntityLink:_linkEntity didSuccess:^{
        self.entityLink_list = [_entityLinkProcess findEntityLinkForEntity:_linkEntity];
        [self.baseTableView reloadData];
    }didFail:^{
        
    }];
}

-(IBAction)saveLinkDevice:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@",_linkEntity.entityID];
    int i = 0;
    if ([entityLink_list count] >= 20) {
        [self showFailHUD:@"设备联动不能超过20个"];
        return;
    }
    for (EntityLink *tempLink in entityLink_list) {
        if (i == 0) {
            msg = [NSString stringWithFormat:@"%@&%@@%d@%d",msg,tempLink.entityId, tempLink.entityLineNum, tempLink.state];
        }else{
            msg = [NSString stringWithFormat:@"%@,%@@%d@%d",msg,tempLink.entityId, tempLink.entityLineNum, tempLink.state];
        }
        i++;
    }
    
    [self showMyHUD:@"加载中"];
    [[Interface shareInterface:nil] writeFormatDataAction:@"18" didMsg:msg didCallBack:^(NSString *code) {
        if (![code isEqualToString:@"1"]) {
            [self showSuccessHUD:@"联动管理操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showFailHUD:@"操作失败"];
        }
    }];
}

#pragma mark -
#pragma mark DeviceLinkCellDelegate
-(void) setStateWithSender:(id)sender
{
    UISwitch *switchBut = (UISwitch *)sender;
    BaseModel *baseModel = [entity_list objectAtIndex:switchBut.tag];
    EntityLink *entityLink;
    if ([baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)baseModel;
        entityLink = [self iskindOfEntityId:entity];
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
        
        EntityLine *entityLine = (EntityLine *)baseModel;
        entityLink = [self iskindOfEntityId:entityLine];
        entityLink.entityLineNum = [entityLine.entityLineNum intValue];
    }
    
    if (switchBut.isOn) {
        entityLink.state = 0;
    }else{
        entityLink.state = 1;
    }
}

-(IBAction)selectLinkEntityAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    [self selectOrCancelEntityLink:but.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [entity_list count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
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
    DeviceLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceLink" forIndexPath:indexPath];
    BaseModel *entity = [entity_list objectAtIndex:indexPath.row];
    [cell setEntity:entity];
    cell.deviceSwitch.tag = indexPath.row;
    cell.selectBut.tag = indexPath.row;
    cell.delegate = self;
    
    EntityLink *entityLink;
    
    if ([entity isKindOfClass:[Entity class]]) {
        Entity *entity1 = (Entity *)entity;
        entityLink = [self iskindOfEntityId:entity1];
    }else if ([entity isKindOfClass:[EntityLine class]]) {
        EntityLine * entityline = (EntityLine *)entity;
        entityLink = [self iskindOfEntityId:entityline];
    }
    
    if (entityLink) {
        [cell setViewButAction:YES];
    }else{
        [cell setViewButAction:NO];
    }
    
    if (entityLink.state == 0) {
        [cell.deviceSwitch setOn:YES];
    }else{
        [cell.deviceSwitch setOn:NO];
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self selectOrCancelEntityLink:indexPath.row];
}

-(void) selectOrCancelEntityLink:(int)index
{
    BaseModel *baseModel = [entity_list objectAtIndex:index];
    EntityLink *entityLink;
    
//    设备或设备路
    if ([baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)baseModel;
        entityLink = [self iskindOfEntityId:entity];
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
        EntityLine *entityline = (EntityLine *)baseModel;
        entityLink = [self iskindOfEntityId:entityline];
    }
    
    if (entityLink) { //取消
        
        [entityLink_list removeObject:entityLink];
    }else{ //选中
        entityLink = [[EntityLink alloc] init];
        if ([baseModel isKindOfClass:[Entity class]]) {
            Entity *entity = (Entity *)baseModel;
            entityLink.entityId = entity.entityID;
            entityLink.entityLineNum = 0;
        }else if ([baseModel isKindOfClass:[EntityLine class]]) {
            EntityLine *entityline = (EntityLine *)baseModel;
            entityLink.entityId = entityline.entityID;
            entityLink.entityLineNum = [entityline.entityLineNum intValue];
        }
        entityLink.state = 1;
        [entityLink_list addObject:entityLink];
    }
    
    [self.baseTableView reloadData];
}

//判断设备列表是否已经选中
-(EntityLink *) iskindOfEntityId:(BaseModel *)entity
{
    for (EntityLink *entityLink in entityLink_list) {
        
        if ([entity isKindOfClass:[EntityLine class]]) {
            EntityLine *entityLine = (EntityLine *)entity;
            if ([entityLine.entityID isEqualToString:entityLink.entityId] && [entityLine.entityLineNum intValue] == entityLink.entityLineNum) {
                return entityLink;
            }
            
        }else if ([entity isKindOfClass:[Entity class]]) {
            Entity *entityTemp = (Entity *)entity;
            if ([entityTemp.entityID isEqualToString:entityLink.entityId]) {
                return entityLink;
            }
        }
    }
    return nil;
}

@end
