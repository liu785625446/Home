//
//  MRoomSelectViewController.m
//  Home
//
//  Created by 刘军林 on 15/5/29.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MRoomSelectViewController.h"
#import "Rooms.h"
#import "RoomsProcess.h"
#import "Entity.h"
#import "Interface.h"
#import "EntityProcess.h"
#import "EntityLineProcess.h"
#import "EntityLine.h"
#import "EntityRemote.h"
#import "EntityRemoteProcess.h"
#import "Camerainfos.h"
#import "CamerainfosProcess.h"

@interface MRoomSelectViewController ()

@property (nonatomic, strong) RoomsProcess *roomsProcess;
@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) EntityLineProcess *entityLineProcess;
@property (nonatomic, strong) EntityRemoteProcess *entityRemoteProcess;

@property (nonatomic, strong) CamerainfosProcess *camerainfosProcess;

@end

@implementation MRoomSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _roomsProcess = [[RoomsProcess alloc] init];
    _entityProcess = [[EntityProcess alloc] init];
    _entityLineProcess = [[EntityLineProcess alloc] init];
    _entityRemoteProcess = [[EntityRemoteProcess alloc] init];
    _camerainfosProcess = [[CamerainfosProcess alloc] init];
    
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    _roomList = [_roomsProcess findAll];
    [self.baseTableView reloadData];
    [_roomsProcess synchronousRooms:^(NSMutableArray *array) {
        _roomList = [_roomsProcess findAll];
        [self.baseTableView reloadData];
    } didFail:^{
        
    }];
    // Do any additional setup after loading the view.
}

#pragma mark -
-(IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_roomList count];
}

-(float) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RoomsIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Rooms *rooms = [_roomList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.text = rooms.roomName;
    
    if ([_baseModel isKindOfClass:[EntityLine class]]) {
        EntityLine *_entityLine = (EntityLine *)_baseModel;
        if ([_entityLine.roomId isEqualToString:rooms.roomId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if ([_baseModel isKindOfClass:[Entity class]]) {
        Entity *_entity = (Entity *)_baseModel;
        if ([rooms.roomId isEqualToString:_entity.roomId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if ([_baseModel isKindOfClass:[EntityRemote class]]) {
        EntityRemote *entityRemote = (EntityRemote *)_baseModel;
        if ([rooms.roomId isEqualToString:entityRemote.roomId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if ([_baseModel isKindOfClass:[Camerainfos class]]) {
        Camerainfos *cameraInfo = (Camerainfos *)_baseModel;
        if ([rooms.roomId isEqualToString:cameraInfo.roomId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkConnectionStatus]) {
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if ([_baseModel isKindOfClass:[EntityLine class]]) {
        EntityLine *_entityLine = (EntityLine *)_baseModel;
        Rooms *rooms = [_roomList objectAtIndex:indexPath.row];
        NSString * msg = [NSString stringWithFormat:@"%@&%@&%@&%d&%d&%@",_entityLine.entityID,_entityLine.entityLineNum,_entityLine.entityLineName,_entityLine.icon,_entityLine.enabled,rooms.roomId];
        
        [self showMyHUD:@"加载中"];
        [_entityProcess editDeviceLineMsg:msg success:^(NSString *code) {
            [self showSuccessHUD:@"添加成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } fail:^(NSError *result, NSString *errInfo) {
            [self showFailHUD:@"添加失败"];
        }];
        
    }else if ([_baseModel isKindOfClass:[Entity class]]) {
        Entity *_entity = (Entity *)_baseModel;
        Rooms *rooms = [_roomList objectAtIndex:indexPath.row];
        NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%d&%@",_entity.entityID, @"0", _entity.entityName, _entity.icon, rooms.roomId];
        [self showMyHUD:@"加载中"];
        [_entityProcess editDeviceMsg:msg success:^(NSString *code) {
            [self showSuccessHUD:@"添加成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } fail:^(NSError *result, NSString *errInfo) {
            [self showFailHUD:@"添加失败"];
        }];
    }else if ([_baseModel isKindOfClass:[EntityRemote class]]) {
        EntityRemote *entityRemote = (EntityRemote *)_baseModel;
        
        Rooms *rooms = [_roomList objectAtIndex:indexPath.row];
        NSString *msg = [NSString stringWithFormat:@"%d&%d&%@&%d&%@",0,entityRemote.entityRemoteIndex,entityRemote.entityRemoteName,entityRemote.entityRemoteIcon,rooms.roomId];
        [self showMyHUD:@"加载中"];
        [_entityRemoteProcess editEntityRemoteMsg:msg success:^(NSString *code) {
            [self showSuccessHUD:@"添加成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } fail:^(NSError *result, NSString *errInfo) {
            [self showFailHUD:@"添加失败"];
        }];
    }else if ([_baseModel isKindOfClass:[Camerainfos class]]) {
        Camerainfos *camerainfo = (Camerainfos *)_baseModel;
        
        Rooms *rooms = [_roomList objectAtIndex:indexPath.row];
        [self showMyHUD:@"加载中"];
        NSString *msg = [NSString stringWithFormat:@"%@&%@&%@&%@",BOX_ID_VALUE, camerainfo.cameraNum, camerainfo.cameraName, rooms.roomId];
        [[Interface shareInterface:nil] writeFormatDataAction:@"20" didMsg:msg didCallBack:^(NSString *code) {
            if (![code isEqualToString:@"1"]) {
                [_camerainfosProcess synchronousCamerainfos:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSuccessHUD:@"添加成功"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                } didFail:^{
                    
                }];
            }
        }];
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
