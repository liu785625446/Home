
//
//  MDeviceViewController.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceViewController.h"
#import "EntityProcess.h"
#import "Entity.h"
#import "MDeviceRoomHeadCell.h"
#import "EntityLine.h"
#import "Interface.h"

#import "EntityLineProcess.h"

#import "MainClass.h"
#import "MessagePool.h"

#import "MHorizontalSlidingView.h"
#import "MSliderLabelView.h"
#import "MDeviceInfoCell.h"
#import "MDeviceStartCell.h"
#import "MDeviceCurtainCell.h"
#import "RoomsProcess.h"
#import "Rooms.h"
#import "EntityRemote.h"
#import "MDeviceAirCell.h"
#import "MDeviceTVCell.h"
#import "DeviceType.h"

#define CURRENT_TAG @"current_tag"
#define ROOM_DEVICE_LIST @"room_device_list"


@interface MDeviceViewController () <MessagePoolDelegate,UIAlertViewDelegate,MHorizontalSlidingViewDelegate, UITableViewDelegate, UITableViewDataSource, MSliderLabelViewDelegate,MDeviceRoomHeadCellDelegate,MDeviceStartCellDelegate,MDeviceCurtainCellDelegate>

@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) RoomsProcess *roomsProcess;
@property (nonatomic, strong) MainClass *mainClass;

@property (nonatomic, strong) MSliderLabelView *sliderTitle;

//@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation MDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _entityProcess = [[EntityProcess alloc] init];
    _mainClass = [[MainClass alloc] initWithDelegate:self];
    _roomsProcess = [[RoomsProcess alloc] init];
//    _lock = [[NSRecursiveLock alloc] init];
    _runCurrentRow = -1;
    
    _roomArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _device_type_array = [[NSMutableArray alloc] initWithCapacity:0];
    _runArray = [[NSMutableArray alloc] initWithCapacity:0];
    _room_device_array = [[NSMutableArray alloc] initWithCapacity:0];
    [_slidingView setItemsAttribute:3 SlidingViewDelegate:self tableDelegate:self tableDataSource:self];
    [self.view addSubview:_slidingView];
    
    _sliderTitle = [[MSliderLabelView alloc] initWithFrame:CGRectZero itemsTitles:@[@"房间",@"设备",@"运行"] itemHighlight:1];
    self.tabBarController.navigationItem.titleView = _sliderTitle;
    _sliderTitle.delegate = self;
    [_sliderTitle setHighlightOfIndex:0];

    [self receivDeviceBoradcastData];
    
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([Interface shareInterface:nil].isConnection) {
        self.tabBarController.navigationItem.titleView = _sliderTitle;
    }else{
        self.tabBarController.navigationItem.titleView = nil;
        self.tabBarController.navigationItem.title = @"未连接...";
    }
    [self synEntityData];
    
//    观察连接是否在线
    Interface *interface = [Interface shareInterface:nil];
    [interface addObserver:self forKeyPath:@"isConnection" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
//    [MTopWarnView addTopNetworkText:@"连接失败，请查看网络设置"];
}

-(void) monitorRefresh
{
    [_slidingView reloadSlidingView];
    [_currentTable reloadData];
    [_slidingView.currentTable reloadData];
}

#pragma mark Action
-(void) synEntityData
{
//    设备基本数据
    _roomArray = [_roomsProcess findAll];
    _baseDeviceList = [_entityProcess findCanControlEntity];
    _runArray = [self getRuningDevice:_baseDeviceList];
    _device_type_array = [self getDeviceTypeTitle:_baseDeviceList];
    _room_device_array = _baseDeviceList;
    [_slidingView reloadSlidingView];
    
    [_roomsProcess synchronousRooms:^(NSMutableArray *array) {
        [_entityProcess synchronousEntity:^{
            _roomArray = [_roomsProcess findAll];
            _baseDeviceList = [_entityProcess findCanControlEntity];
            _runArray = [self getRuningDevice:_baseDeviceList];
            _device_type_array = [self getDeviceTypeTitle:_baseDeviceList];
            _room_device_array = _baseDeviceList;
            [_entityProcess refreshDeviceBoradcastData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_currentTable reloadData];
            });
        } didFail:^{
            
        }];
    } didFail:^{
        
    }];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL old = [[change objectForKey:@"old"] intValue];
    BOOL new = [[change objectForKey:@"new"] intValue];
    
    if (self.tabBarController.selectedIndex == 1) {
        if (old != new) {
            if (new) {
                self.tabBarController.navigationItem.titleView = _sliderTitle;
            }else{
                self.tabBarController.navigationItem.titleView = nil;
                self.tabBarController.navigationItem.title = @"未连接...";
            }
        }
    }
}

-(void) refreshHeaderBlock
{
    
}

//初始化数据源
-(void) loadDatasource
{
    NSMutableArray *array = [_entityProcess findCanControlEntity];
}

#pragma mark MHorizontalSlidingView
-(void) horizontalSlidingView:(MHorizontalSlidingView *)slidingView scrollRow:(NSInteger)row currentTable:(UITableView *)tableView
{
    _currentTableTag = row;
    [_sliderTitle setHighlightOfIndex:row];
    [self monitorRefresh];
}

-(void) horizontalScrollingView:(MHorizontalSlidingView *)slidingView scrollingOff:(NSInteger)row
{
    _currentTableTag = row;
}

-(void) horizontalSlidingView:(MHorizontalSlidingView *)slidingView MJRefresh:(MJRefreshBaseView *)refreshView
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
//        [_lock lock];
        _roomArray = [_roomsProcess findAll];
        _baseDeviceList = [_entityProcess findCanControlEntity];
        _runArray = [self getRuningDevice:_baseDeviceList];
        _device_type_array = [self getDeviceTypeTitle:_baseDeviceList];
        _room_device_array = _baseDeviceList;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshView endRefreshing];
        });
        
        [_roomsProcess synchronousRooms:^(NSMutableArray *array) {
            [_entityProcess synchronousEntity:^{
                _roomArray = [_roomsProcess findAll];
                _baseDeviceList = [_entityProcess findCanControlEntity];
                _runArray = [self getRuningDevice:_baseDeviceList];
                _device_type_array = [self getDeviceTypeTitle:_baseDeviceList];
                _room_device_array = _baseDeviceList;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_entityProcess refreshDeviceBoradcastData];
                    [_slidingView reloadSlidingView];
                    
                    id refreshTable = [refreshView superview];
                    if ([refreshView isKindOfClass:[UITableView class]]) {
                        [((UITableView *)refreshTable) reloadData];
                    }
                    [refreshView endRefreshing];
                });

//                [_lock unlock];
                
            } didFail:^{

//                [_lock unlock];
            }];
        } didFail:^{

//            [_lock unlock];
        }];
//    });
}

#pragma mark MSlideLabelViewDelegate
-(void) sliderLabelView:(MSliderLabelView *)sliderLabel selectOfIndex:(NSInteger)index
{
    [_slidingView setScrollPage:index];
    [self monitorRefresh];
}

#pragma mark MDeviceRoomHeadCellDelegate
-(void) MDeviceRoomHead:(MDeviceRoomHeadCell *)roomHead didSelectSection:(NSInteger)section
{
    if (_currentTableTag == 0) {
        Rooms *rooms = [_roomArray objectAtIndex:section];
        if (rooms.isOpen) {
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i=0 ; i<[rooms.roomDeviceList count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [indexPathArray addObject:indexPath];
            }
            [rooms.roomDeviceList removeAllObjects];
            rooms.currentStartRow = -1;
            [_currentTable deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            rooms.isOpen = NO;
            [roomHead.downImg setImage:[UIImage imageNamed:@"arrow_grey.png"]];
        }else{
            rooms.roomDeviceList = [self getRoomDeviceListForRoomsId:rooms.roomId];
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (int i=0 ; i<[rooms.roomDeviceList count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [indexPathArray addObject:indexPath];
            }
            [_currentTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            rooms.isOpen = YES;
            [roomHead.downImg setImage:[UIImage imageNamed:@"arrow_blue.png"]];
        }
    }else if (_currentTableTag == 1) {
        DeviceType *devicetype = [_device_type_array objectAtIndex:section];
        if (devicetype.isOpen) {
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i=0 ; i<[devicetype.deviceList count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [indexPathArray addObject:indexPath];
            }
            [devicetype.deviceList removeAllObjects];
            devicetype.currentStartRow = -1;
            [_currentTable deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            devicetype.isOpen = NO;
            [roomHead.downImg setImage:[UIImage imageNamed:@"arrow_grey.png"]];
        }else{
            devicetype.deviceList = [self getDeviceTypeList:devicetype.deviceType];
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (int i=0 ; i<[devicetype.deviceList count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [indexPathArray addObject:indexPath];
            }
            [_currentTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            devicetype.isOpen = YES;
            [roomHead.downImg setImage:[UIImage imageNamed:@"arrow_blue.png"]];
        }
    }
}

-(NSMutableArray *) getRoomDeviceListForRoomsId:(NSString *)roomId
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (BaseModel *entity in _room_device_array) {
        if ([entity isKindOfClass:[Entity class]]) {
            if ([((Entity *)entity).roomId isEqualToString:roomId]) {
                [array addObject:entity];
            }
        }else if ([entity isKindOfClass:[EntityLine class]]){
            if ([((EntityLine *)entity).roomId isEqualToString:roomId] && ((EntityLine *)entity).enabled == 0) {
                [array addObject:entity];
            }
        }else if ([entity isKindOfClass:[EntityRemote class]]) {
            if ([((EntityRemote *)entity).roomId isEqualToString:roomId]) {
                [array addObject:entity];
            }
        }
    }
    return array;
}

-(NSMutableArray *) getRuningDevice:(NSMutableArray *)array
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    for (BaseModel *baseModel in array) {
        if ([baseModel isKindOfClass:[Entity class]]) {
            Entity *entity = (Entity *)baseModel;
            if (entity.state == 0) {
                [temp addObject:entity];
            }
        }else if ([baseModel isKindOfClass:[EntityLine class]]) {
            EntityLine *entityLine = (EntityLine *)baseModel;
            if (entityLine.state == 0 && entityLine.enabled == 0) {
                [temp addObject:entityLine];
            }
        }
    }
    return temp;
}

-(NSMutableArray *) getDeviceTypeTitle:(NSMutableArray *)array
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (BaseModel *baseModel in array) {
        if ([baseModel isKindOfClass:[Entity class]]) {
            
            Entity *entity = (Entity *)baseModel;
            
            if ([entity.entityType intValue] == SOCKET_SWITCH) {
                BOOL exis = NO;
                for (DeviceType *deviceType in temp) {
                    if ([deviceType.deviceType intValue] == SOCKET_SWITCH) {
                        exis = YES;
                    }
                }
                if (!exis) {
                    DeviceType *devicetype = [[DeviceType alloc] init];
                    devicetype.deviceType = [NSString stringWithFormat:@"%d",SOCKET_SWITCH];
                    [temp addObject:devicetype];
                }
            }else if ([entity.entityType intValue] == CURTAIN_SWITCH) {
                BOOL exis = NO;
                for (DeviceType *deviceType in temp) {
                    if ([deviceType.deviceType intValue] == CURTAIN_SWITCH) {
                        exis = YES;
                    }
                }
                if (!exis) {
                    DeviceType *devicetype = [[DeviceType alloc] init];
                    devicetype.deviceType = [NSString stringWithFormat:@"%d",CURTAIN_SWITCH];
                    [temp addObject:devicetype];
                }
            }else if ([entity.entityType intValue] == MAGNETIC) {
                
                BOOL exis = NO;
                for (DeviceType *deviceType in temp) {
                    if ([deviceType.deviceType intValue] == MAGNETIC) {
                        exis = YES;
                    }
                }
                if (!exis) {
                    DeviceType *devicetype = [[DeviceType alloc] init];
                    devicetype.deviceType = [NSString stringWithFormat:@"%d",MAGNETIC];
                    [temp addObject:devicetype];
                }

            }else if ([entity.entityType intValue] == INFRARED_PROBE) {
                
                BOOL exis = NO;
                for (DeviceType *deviceType in temp) {
                    if ([deviceType.deviceType intValue] == INFRARED_PROBE) {
                        exis = YES;
                    }
                }
                if (!exis) {
                    DeviceType *devicetype = [[DeviceType alloc] init];
                    devicetype.deviceType = [NSString stringWithFormat:@"%d",INFRARED_PROBE];
                    [temp addObject:devicetype];
                }

            }else if ([entity.entityType intValue] == GAS_DETECTION) {
                
                BOOL exis = NO;
                for (DeviceType *deviceType in temp) {
                    if ([deviceType.deviceType intValue] == GAS_DETECTION) {
                        exis = YES;
                    }
                }
                if (!exis) {
                    DeviceType *devicetype = [[DeviceType alloc] init];
                    devicetype.deviceType = [NSString stringWithFormat:@"%d",GAS_DETECTION];
                    [temp addObject:devicetype];
                }

            }else if ([entity.entityType intValue] == SMKEN) {
                BOOL exis = NO;
                for (DeviceType *deviceType in temp) {
                    if ([deviceType.deviceType intValue] == SMKEN) {
                        exis = YES;
                    }
                }
                if (!exis) {
                    DeviceType *devicetype = [[DeviceType alloc] init];
                    devicetype.deviceType = [NSString stringWithFormat:@"%d",SMKEN];
                    [temp addObject:devicetype];
                }

            }
            
        }else if ([baseModel isKindOfClass:[EntityLine class]]) {
            BOOL exis = NO;
            for (DeviceType *deviceType in temp) {
                if ([deviceType.deviceType intValue] == PANEL_SWITCH_3  || [deviceType.deviceType intValue] == PANEL_SWITCH_2 || [deviceType.deviceType intValue] == PANEL_SWITCH_1) {
                    exis = YES;
                    break;
                }
            }
            if (!exis) {
                DeviceType *devicetype = [[DeviceType alloc] init];
                devicetype.deviceType = [NSString stringWithFormat:@"%d",PANEL_SWITCH_3];
                [temp addObject:devicetype];
            }
        }else if ([baseModel isKindOfClass:[EntityRemote class]]) {
            BOOL exis = NO;
            for (DeviceType *deviceType in temp) {
                if ([deviceType.deviceType intValue] == REMOTE_INFRARED) {
                    exis = YES;
                    break;
                }
            }
            if (!exis) {
                DeviceType *devicetype = [[DeviceType alloc] init];
                devicetype.deviceType = [NSString stringWithFormat:@"%d",REMOTE_INFRARED];
                [temp addObject:devicetype];
            }
        }
    }
    return temp;
}

-(NSMutableArray *) getDeviceTypeList:(NSString *)type
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    for (BaseModel *baseModel in _baseDeviceList) {
        if ([type intValue] == REMOTE_INFRARED && [baseModel isKindOfClass:[EntityRemote class]]) {
            [temp addObject:baseModel];
        }else if (([type intValue] == PANEL_SWITCH_3  || [type intValue] == PANEL_SWITCH_2 || [type intValue] == PANEL_SWITCH_1) && [baseModel isKindOfClass:[EntityLine class]]) {
            if (((EntityLine *)baseModel).enabled == 0) {
                [temp addObject:baseModel];
            }
        }else{
            if ([baseModel isKindOfClass:[Entity class]]) {
                Entity *entity = (Entity *)baseModel;
                if ([entity.entityType intValue] == [type intValue]) {
                    [temp addObject:entity];
                }
            }
        }
    }
    return temp;
}

#pragma 接收设备广播帧数据
-(void) receivDeviceBoradcastData
{
    [[Interface shareInterface:self] setSwitchBlock:^(NSString *code){
        
        NSArray *array = [code componentsSeparatedByString:@"&"];
        NSString *entityId = @"";
        int power = 0;
        if ([array count] > 0) {
            entityId = [array objectAtIndex:0];
        }
        if ([array count] == 5) {
            power = [[array objectAtIndex:4] intValue];
        }
        
//        删除当前设备的消息池
        for (MessagePool *pool in _mainClass.messagePoolList) {
            if ([pool.entityId isEqualToString:entityId]) {
                [pool.timer invalidate];
                pool.timer = nil;
                [_mainClass.messagePoolList removeObject:pool];
                break;
            }
        }
        
        EntityLineProcess *entityLineProcess = [[EntityLineProcess alloc] init];
        EntityProcess *entityProcess = [[EntityProcess alloc] init];
        for (BaseModel *model in _baseDeviceList) {
//            设备广播帧
            if ([model isKindOfClass:[Entity class]]) {
                Entity *entity = (Entity *)model;
                
                if ([entity.entityID isEqualToString:entityId] && [entity.entityType intValue] !=  PANEL_SWITCH_3  && [entity.entityType intValue] != PANEL_SWITCH_2 && [entity.entityType intValue] != PANEL_SWITCH_1 && [entity.entityType intValue] != CURTAIN_SWITCH) {
                    entity.state = [[array objectAtIndex:2] intValue];
                    entity.switchState = entity.state;
                    entity.isAnimation = NO;
                    entity.entitySignal = [array objectAtIndex:3];
//                    static int i=0;
//                    entity.entityName = [NSString stringWithFormat:@"广播成功%d",i];
//                    [self showSuccessHUD:[NSString stringWithFormat:@"广播成功%d",i]];
                    //                    门磁电量
                    if ([entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == SMKEN || [entity.entityType intValue] == INFRARED_PROBE) {
                        entity.power = power;
                    }
                    [entityProcess updateEntity:entity];
                    break;
                }else if ([entity.entityType intValue] == CURTAIN_SWITCH && [entity.entityID isEqualToString:entityId]) {
                    entity.state = [[array objectAtIndex:2] intValue];
                    entity.switchState = entity.state;
                    if (entity.state == 0) {
                        entity.isLeftAnimation = NO;
                    }else if (entity.state == 2) {
                        entity.isMiddleAnimation = NO;
                    }else if (entity.state == 1) {
                        entity.isRightAnimation = NO;
                    }else if (entity.state == 3) {
                        entity.isLeftAnimation = NO;
                        entity.isMiddleAnimation = NO;
                        entity.isRightAnimation = NO;
                    }
                    entity.entitySignal = [array objectAtIndex:3];
                    [entityProcess updateEntity:entity];
                }
                //                设备路广播帧
            }else if ([model isKindOfClass:[EntityLine class]]){
                EntityLine *entityLine = (EntityLine*) model;
                NSString *entityNum = @"";
                if ([array count] > 2) {
                    entityNum = [array objectAtIndex:1];
                }
                //                判断当前设备路
                if ([entityLine.entityID isEqualToString:entityId] && [entityLine.entityLineNum isEqualToString:entityNum]) {
                    entityLine.state = [[array objectAtIndex:2] intValue];
                    entityLine.entitySignal = [array objectAtIndex:3];
                    entityLine.switchState = entityLine.state;
                    entityLine.isAnimation = NO;
//                    entityLine.entityLineName = code;
                    [entityLineProcess updateEntityLine:entityLine];
                    break;
                }
            }
        }
        _runCurrentRow = -1;
        _runArray = [self getRuningDevice:_baseDeviceList];
        [_slidingView reloadSlidingView];
        [_currentTable reloadData];
        [_currentTable reloadSectionIndexTitles];
    }];
}

#pragma mark 
#pragma mark UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_currentTableTag == 0) {
        return [_roomArray count];
    }else if (_currentTableTag == 1) {
        return [_device_type_array count];
    }
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentTableTag == 0) {
        if ([_roomArray count] > section) {
            Rooms *rooms = [_roomArray objectAtIndex:section];
            return [rooms.roomDeviceList count];
        }else {
            return 0;
        }
        
    }else if (_currentTableTag == 1) {
        if ([_device_type_array count] > section) {
            DeviceType *deviceType = [_device_type_array objectAtIndex:section];
            return [deviceType.deviceList count];
        }else {
            return 0;
        }
    }else {
        return [_runArray count];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    if (_currentTableTag == 0) {
        Rooms *rooms = [_roomArray objectAtIndex:indexPath.section];
        if (rooms.currentStartRow == indexPath.row) {
            
            BaseModel *baseModel = [rooms.roomDeviceList objectAtIndex:indexPath.row-1];
            if ([baseModel isKindOfClass:[EntityRemote class]]) {
                EntityRemote *entityRemote = (EntityRemote *)baseModel;
                if (entityRemote.brandType == 0) {
                    return 370.0f;
                }else {
                    return 290.0f;
                }
                
            }
            return 100.0f;
        }
    }else if (_currentTableTag == 1) {
        DeviceType *deviceType = [_device_type_array objectAtIndex:indexPath.section];
        if (indexPath.row == deviceType.currentStartRow) {
            BaseModel *baseModel = [deviceType.deviceList objectAtIndex:indexPath.row-1];
            if ([baseModel isKindOfClass:[EntityRemote class]]) {
                EntityRemote *entityRemote = (EntityRemote *)baseModel;
                if (entityRemote.brandType == 0) {
                    return 370.0f;
                }else {
                    return 290.0f;
                }
                
            }
            return 100.0f;

        }
    }else {
        if (indexPath.row == _runCurrentRow) {
            BaseModel *baseModel = [_runArray objectAtIndex:indexPath.row-1];
            if ([baseModel isKindOfClass:[EntityRemote class]]) {
                EntityRemote *entityRemote = (EntityRemote *)baseModel;
                if (entityRemote.brandType == 0) {
                    return 370.0f;
                }else {
                    return 290.0f;
                }
                
            }
            return 100.0f;

        }
    }
    return 70.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_currentTableTag == 0 || _currentTableTag == 1) {
        return 10;
    }
    
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_currentTableTag == 0 || _currentTableTag == 1) {
        return 60;
    }
    return 0.1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _currentTable = tableView;
    if (_currentTableTag == 0) {
        MDeviceRoomHeadCell *headCell = [[[NSBundle mainBundle] loadNibNamed:@"MDeviceRoomHeadCell" owner:self options:nil] objectAtIndex:0];
        CGRect cellRect = headCell.frame;
        cellRect.origin.x = 0;
        cellRect.origin.y = 0;
        headCell.frame = cellRect;
        headCell.delegate = self;
        headCell.tag = section;
        
        Rooms *rooms = [_roomArray objectAtIndex:section];
        NSMutableArray *roomRuning = [self getRoomDeviceListForRoomsId:rooms.roomId];
        int deviceNumber = [[self getRoomDeviceListForRoomsId:rooms.roomId] count];
        int runNumber = [[self getRuningDevice:roomRuning] count];
        if (rooms.isOpen) {
            [headCell.downImg setImage:[UIImage imageNamed:@"arrow_blue.png"]];
            headCell.topConstraint.constant = 0.4f;
            headCell.bottomConstraint.constant = 0.f;
        }else{
            [headCell.downImg setImage:[UIImage imageNamed:@"arrow_grey.png"]];
            headCell.topConstraint.constant = 0.4f;
            headCell.bottomConstraint.constant = 0.4f;
        }
        headCell.roomName.text = rooms.roomName;
        headCell.roomAmount.text = [NSString stringWithFormat:@"%d/%d",runNumber,deviceNumber];
        return headCell;
    }else if (_currentTableTag == 1){
        MDeviceRoomHeadCell *headCell = [[[NSBundle mainBundle] loadNibNamed:@"MDeviceRoomHeadCell" owner:self options:nil] objectAtIndex:0];
        CGRect cellRect = headCell.frame;
        cellRect.origin.x = 0;
        cellRect.origin.y = 0;
        headCell.frame = cellRect;
        headCell.delegate = self;
        headCell.tag = section;
        
        DeviceType *deviceType = [_device_type_array objectAtIndex:section];
        
        NSMutableArray *roomRuning = [self getDeviceTypeList:deviceType.deviceType];
        int deviceNumber = [roomRuning count];
        int runNumber = [[self getRuningDevice:roomRuning] count];
        if (deviceType.isOpen) {
            [headCell.downImg setImage:[UIImage imageNamed:@"arrow_blue.png"]];
            headCell.topConstraint.constant = 0.4f;
            headCell.bottomConstraint.constant = 0.f;
        }else{
            [headCell.downImg setImage:[UIImage imageNamed:@"arrow_grey.png"]];
            headCell.topConstraint.constant = 0.4f;
            headCell.bottomConstraint.constant = 0.4f;
        }
        headCell.roomName.text = deviceType.deviceTypeTitle;
        headCell.roomAmount.text = [NSString stringWithFormat:@"%d/%d",runNumber,deviceNumber];
        return headCell;
    }else{
        return nil;
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_currentTableTag == 0 || _currentTableTag == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return headView;
    }
    return nil;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger commonRow = -1;
    NSMutableArray *commonArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (_currentTableTag == 0) {
        Rooms *rooms = [_roomArray objectAtIndex:indexPath.section];
        commonRow = rooms.currentStartRow;
        commonArray = rooms.roomDeviceList;
        
    }else if (_currentTableTag == 1) {
        DeviceType *deviceType = [_device_type_array objectAtIndex:indexPath.section];
        commonRow = deviceType.currentStartRow;
        commonArray = deviceType.deviceList;
    }else {
        commonRow = _runCurrentRow;
        commonArray = _runArray;
    }
    
    if (indexPath.row == commonRow) {
        
        BaseModel *baseModel = [commonArray objectAtIndex:indexPath.row - 1];
        if ([baseModel isKindOfClass:[Entity class]]) {
            Entity *entity = (Entity *)baseModel;
            if ([entity.entityType intValue] == CURTAIN_SWITCH) {
                static NSString *identy = @"curtainIdentifier";
                MDeviceCurtainCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
                if (!cell) {
                    UINib *nib = [UINib nibWithNibName:@"MDeviceCurtainCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:identy];
                    cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
                }
                cell.delegate = self;
                [cell setBaseModel:entity];
                cell.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
                return cell;
            }
        }
        
        if ([baseModel isKindOfClass:[EntityRemote class]]) {
            
            EntityRemote *entityRemote = (EntityRemote *)baseModel;
            if (entityRemote.brandType == 0) {
                static NSString *identy = @"MDeviceTVIdentifier";
                MDeviceTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
                if (!cell) {
                    UINib *nib = [UINib nibWithNibName:@"MDeviceTVCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:identy];
                    cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
                }
                [cell setEntityRemote:baseModel];
                return cell;
            }else{
                static NSString *identy = @"MDeviceAirIdentifier";
                MDeviceAirCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
                if (!cell) {
                    UINib *nib = [UINib nibWithNibName:@"MDeviceAirCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:identy];
                    cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
                }
                [cell setEntityRemote:baseModel];
                return cell;
            }
        }
        
        static NSString *identy = @"MDeviceStartCell";
        MDeviceStartCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
        if (!cell) {
            UINib *nib = [UINib nibWithNibName:@"MDeviceStartCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identy];
            
            cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
        }
        cell.delegate = self;
        [cell setBaseModel:baseModel];
        return cell;
    }else{
        static NSString *identy = @"MDeviceInfoIdentifier";
        MDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];

        if (!cell) {
            UINib *nib = [UINib nibWithNibName:@"MDeviceInfoCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identy];
            
            cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
        }
        if ([commonArray count] > indexPath.row) {
            BaseModel *baseModel = [commonArray objectAtIndex:indexPath.row];
            [cell setBaseModel:baseModel];
        }
        
        if (commonRow == indexPath.row + 1) {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.frame.size.width, 0, 0);
            cell.upImg.hidden = NO;
        }else {
            cell.separatorInset = tableView.separatorInset;
            cell.upImg.hidden = YES;
        }
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentTableTag == 0) {
        Rooms *rooms = [_roomArray objectAtIndex:indexPath.section];
        NSInteger roomsRow = rooms.currentStartRow;
        [self selectSwitchAction:tableView IndexPath:indexPath sourceArray:rooms.roomDeviceList currentRow:&roomsRow rooms:rooms deviceType:nil];
    }else if (_currentTableTag == 1) {
        DeviceType *deviceType = [_device_type_array objectAtIndex:indexPath.section];
        NSInteger roonsRow = deviceType.currentStartRow;
        [self selectSwitchAction:tableView IndexPath:indexPath sourceArray:deviceType.deviceList currentRow:&roonsRow rooms:nil deviceType:deviceType];
    }else {
        [self selectSwitchAction:tableView IndexPath:indexPath sourceArray:_runArray currentRow:&_runCurrentRow rooms:nil deviceType:nil];
    }
}

-(void) selectSwitchAction:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath sourceArray:(NSMutableArray *)sourceArray currentRow:(NSInteger *)currentRow rooms:(Rooms *)rooms deviceType:(DeviceType *)deviceType
{
    if (_tapTimer) { //点击响应时间
        return;
    }
    if (indexPath.row + 1 == *currentRow) { //收起start
        [sourceArray removeObjectAtIndex:*currentRow];
        *currentRow = -1;
        if (_currentTableTag == 0) {
            rooms.currentStartRow = -1;
        }else if (_currentTableTag == 1) {
            deviceType.currentStartRow = -1;
        }
//        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
        [_currentTable reloadData];
    }else{
        if (*currentRow > 0) {
            NSInteger temp = *currentRow;
            [sourceArray removeObjectAtIndex:*currentRow];
            *currentRow = -1;
            if (_currentTableTag == 0) {
                rooms.currentStartRow = -1;
            }else if (_currentTableTag == 1) {
                deviceType.currentStartRow = -1;
            }
//            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:temp inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
            
            if (temp > indexPath.row) {
                *currentRow = indexPath.row + 1;
            }else{
                *currentRow = indexPath.row;
            }
            if (_currentTableTag == 0) {
                rooms.currentStartRow = *currentRow;
            }else if (_currentTableTag == 1) {
                deviceType.currentStartRow = *currentRow;
            }
            _tapTimer = YES;
            __block int blockRow = *currentRow;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sourceArray insertObject:@"" atIndex:blockRow];
//                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:blockRow inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
                _tapTimer = NO;
                
                [_currentTable reloadData];
            });
        }else {
            *currentRow = indexPath.row + 1;
            if (_currentTableTag == 0) {
                rooms.currentStartRow = *currentRow;
            }else if (_currentTableTag == 1) {
                deviceType.currentStartRow = *currentRow;
            }
            [sourceArray insertObject:@"" atIndex:*currentRow];
//            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:*currentRow inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
            [_currentTable reloadData];
        }
    }
}

#pragma mark -
#pragma mark MDeviceStartCellDelegate
-(void) deviceStart:(MDeviceStartCell *)deviceStart tapButton:(UIButton *)tapButton entityID:(NSString *)entityID
{
    [_mainClass.messagePoolList addObject:[[MessagePool alloc] initEntityId:entityID itemsDelegate:self]];
    [_currentTable reloadData];
}

-(void) deviceCurtain:(MDeviceCurtainCell *)deviceCurtain topButton:(UIButton *)but entityID:(NSString *)entityId
{
    [_mainClass.messagePoolList addObject:[[MessagePool alloc] initEntityId:entityId itemsDelegate:self]];
    [_currentTable reloadData];
}

#pragma mark -
#pragma mark MessagePoolDelegate
-(void) handleMessagePool:(MessagePool *)messagePool
{
    for (BaseModel *model in _baseDeviceList) {
        
        if ([model isKindOfClass:[Entity class]]) {
            Entity *entity = (Entity *)model;
            if ([entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == MAGNETIC ||[entity.entityType intValue] == SMKEN || [entity.entityType intValue] == INFRARED_PROBE) {
                if ([entity.entityID isEqualToString:messagePool.entityId]) {
                    entity.switchState = messagePool.state;
                    entity.isAnimation = NO;
                    
                    [messagePool.timer invalidate];
                    messagePool.timer = nil;
                    entity.state = 3;
                    [_mainClass.messagePoolList removeObject:messagePool];
                    
                    [_slidingView reloadSlidingView];
//                    [_slidingView.window makeToast:S_ENTITY_STATUS_CALLBACK_FAIL];
                }
            }else if ([entity.entityType intValue] == CURTAIN_SWITCH) {
                if ([entity.entityID isEqualToString:messagePool.entityId]) {
                    entity.switchState = messagePool.state;
                    entity.isLeftAnimation = NO;
                    entity.isMiddleAnimation = NO;
                    entity.isRightAnimation = NO;
                    [messagePool.timer invalidate];
                    messagePool.timer = nil;
                    entity.state = 3;
                    [_mainClass.messagePoolList removeObject:messagePool];
                    
                    [_slidingView reloadSlidingView];
                }
            }
        }else if ([model isKindOfClass:[EntityLine class]]) {
            EntityLine *entity = (EntityLine *)model;
            if ([entity.entityID isEqualToString:messagePool.entityId]) {
                entity.switchState = messagePool.state;
                entity.isAnimation = NO;
                
                [messagePool.timer invalidate];
                messagePool.timer = nil;
                entity.state = 3;
                [_mainClass.messagePoolList removeObject:messagePool];
                
                [_slidingView reloadSlidingView];
//                [_slidingView.window makeToast:S_ENTITY_STATUS_CALLBACK_FAIL];
            }
        }
    }
    [_currentTable reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
