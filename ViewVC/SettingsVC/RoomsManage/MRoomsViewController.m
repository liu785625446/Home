//
//  MRoomsViewController.m
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MRoomsViewController.h"
#import "Rooms.h"
#import "Interface.h"
#import "RoomsProcess.h"
#import "Tool.h"

@interface MRoomsViewController ()

@end

@implementation MRoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    _updateRoomRow = -1;
    _roomsList = [[NSMutableArray alloc] initWithCapacity:0];
    _roomsProcess = [[RoomsProcess alloc] init];
    [self showMyHUD:@"加载中"];
    [self syncRoomsAction];
    // Do any additional setup after loading the view.
}

#pragma mark Action
     
-(void) syncRoomsAction
{
    _roomsList = [_roomsProcess findAll];
    [self.baseTableView reloadData];
    [_roomsProcess deleteAll];
    [_roomsProcess synchronousRooms:^(NSMutableArray *roomsList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _roomsList = [_roomsProcess findAll];
            [self.baseTableView reloadData];
            [self hideMyHUD];
        });
    } didFail:^{
        
    }];
}
     
-(IBAction)addRoomsAction:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加房间"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"请输入房间名称";
    alert.tag = ROOMADD;
    [alert show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    
        if (alertView.tag == ROOMADD) {
            
            UITextField *tf = [alertView textFieldAtIndex:0];
            if ([tf.text isEqualToString:@""]) {
                [self showFailHUD:@"房间名不能为空"];
                return;
            }
            
            for (Rooms *rooms in _roomsList) {
                if ([rooms.roomName isEqualToString:tf.text]) {
                    [self showFailHUD:@"房间名不能相同"];
                    return;
                }
            }
            
            if ([Tool checkFormatStr:tf.text]) {
                [Tool showMyAlert:S_FORMAT_ERROR];
                return;
            }
            
            [self showMyHUD:@"加载中"];
            __unsafe_unretained id vc = self;
            [_roomsProcess addRooms:tf.text success:^{
                [vc showSuccessHUD:@"添加成功"];
                [vc syncRoomsAction];
            } fail:^(NSError *result, NSString *errInfo) {
                [vc showFailHUD:@"添加失败"];
            }];
            
        }else if (alertView.tag == ROOMUPDATE) {
            
            Rooms *rooms = [_roomsList objectAtIndex:_updateRoomRow];
            UITextField *tf = [alertView textFieldAtIndex:0];
            if ([tf.text isEqualToString:@""]) {
                [self showFailHUD:@"房间名不能为空"];
                return;
            }
            
            for (Rooms *tempRooms in _roomsList) {
                if ([tempRooms.roomName isEqualToString:tf.text] && ![rooms.roomId isEqualToString:tempRooms.roomId] ) {
                    [self showFailHUD:@"房间名不能相同"];
                    return;
                }
            }
            
            if ([Tool checkFormatStr:tf.text]) {
                [Tool showMyAlert:S_FORMAT_ERROR];
                return;
            }
            
            rooms.roomName = tf.text;
            [self showMyHUD:@"加载中"];
            __unsafe_unretained id vc = self;
            [_roomsProcess updateRooms:rooms success:^{
                [vc showSuccessHUD:@"修改成功"];
                [vc syncRoomsAction];
            } fail:^(NSError *result, NSString *errInfo) {
                [vc showFailHUD:@"修改失败"];
            }];
        }
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
    return [_roomsList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }else {
        return 10;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RoomIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Rooms *rooms = [_roomsList objectAtIndex:indexPath.row];
    cell.textLabel.text = rooms.roomName;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    _updateRoomRow = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改房间"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    Rooms *rooms = [_roomsList objectAtIndex:indexPath.row];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.text = rooms.roomName;
    alert.tag = ROOMUPDATE;
    [alert show];
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Rooms *rooms = [_roomsList objectAtIndex:indexPath.row];
        __unsafe_unretained id vc = self;
        [self showMyHUD:@"加载中"];
        [_roomsProcess deleteRooms:rooms.roomId success:^{
            
            [vc showSuccessHUD:@"删除成功"];
            [_roomsList removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [vc syncRoomsAction];
        } fail:^(NSError *result, NSString *errInfo) {
            [vc showFailHUD:@"该房间存在设备无法删除"];
            [vc syncRoomsAction];

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
