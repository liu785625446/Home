//
//  SenceDeviceViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceDeviceViewController.h"
#import "FMDatabase.h"
#import "Entity.h"
#import "EntityRemote.h"
#import "Interface.h"
#import "config.h"
#import "EditSenceDeviceCell.h"
#import "EditSenceRemoteCell.h"
#import "DeviceResource.h"
#import "SenceAirEditViewController.h"
#import "SenceEntity.h"
#import "EntityLine.h"
#import "EntityProcess.h"
#import "EntityRemoteProcess.h"
#import "SenceEntityProcess.h"

@interface SenceDeviceViewController ()

@property (nonatomic, strong) SenceEntityProcess *senceEntityProcess;

@end

@implementation SenceDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseTableView setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
    _entityProcess = [[EntityProcess alloc] init];
    _entityRemoteProcess = [[EntityRemoteProcess alloc] init];
    _senceEntityProcess = [[SenceEntityProcess alloc] init];
    _device_list = [_entityProcess findCanSetSenceEntity];
    if ([_selectDevice_list count] == 0) {
        _selectDevice_list = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.baseTableView reloadData];
    [_senceEntityProcess synchronousSenceEntity:_sence didSuccess:^{
        _selectDevice_list = [_senceEntityProcess findSenceEntityForSence:_sence];
        [self.baseTableView reloadData];
    } didFail:^{
        
    }];
    
    
    // Do any additional setup after loading the view.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}

-(IBAction)saveSenceDevice:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    NSString *msg = @"";
    int i=0;
    int numberPage = _selectDevice_list.count / 10;
    int remainder = _selectDevice_list.count % 10;
    if (remainder > 0) {
        numberPage ++;
    }
    int currentPage = 1;

    if (_sence.senceIndex != 0) {
        [self showMyHUD:@"加载中"];
        for (SenceEntity *senceEntity in _selectDevice_list) {
            if ([msg isEqualToString:@""]) {
                msg = [NSString stringWithFormat:@"%@&%d&%d&%d&%@@%d@%d@%d@%d@%d@%d@%d@%d",BOX_ID_VALUE, numberPage, currentPage, _sence.senceIndex,senceEntity.entityId,senceEntity.entityLineNum,senceEntity.entityRemoteIndex,senceEntity.state,senceEntity.arcPower,senceEntity.arcMode, senceEntity.arcTemp, senceEntity.arcFan, senceEntity.arcFanMode];
            }else{
                msg = [NSString stringWithFormat:@"%@,%@@%d@%d@%d@%d@%d@%d@%d@%d",msg,senceEntity.entityId,senceEntity.entityLineNum,senceEntity.entityRemoteIndex,senceEntity.state,senceEntity.arcPower,senceEntity.arcMode, senceEntity.arcTemp, senceEntity.arcFan, senceEntity.arcFanMode];
            }
            i++;
            if (i==10 || i==_selectDevice_list.count) {
                currentPage ++;
                [[Interface shareInterface:nil] writeFormatDataAction:@"13" didMsg:msg didCallBack:^(NSString *code) {
                    if (![code isEqualToString:@"1"]) {
                        [_senceEntityProcess synchronousSenceEntity:_sence didSuccess:^{
                            _selectDevice_list = [_senceEntityProcess findSenceEntityForSence:_sence];
                            _senceDelegate.device_list = _selectDevice_list;
                            [self.navigationController popViewControllerAnimated:YES];
                            [self showSuccessHUD:@"添加成功"];
                        } didFail:^{
                            
                        }];
                    }
                }];
                msg = @"";
            }
        }
    }else{
        _senceDelegate.device_list = _selectDevice_list;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Action
-(IBAction)deviceSwitchAction:(id)sender
{
    UISwitch *but = (UISwitch *)sender;
    BaseModel *baseModel = [_device_list objectAtIndex:but.tag];
    
    if ([baseModel isKindOfClass:[Entity class]]) {
        SenceEntity *senceEntity = [self isKindSelect:baseModel];
        
        if (but.isOn) {
            senceEntity.state = 0;
        }else{
            senceEntity.state = 1;
        }
        
//        [self updateSenceDevice:senceEntity];
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
        SenceEntity *senceEntity = [self isKindSelect:baseModel];
        
        if (but.isOn) {
            senceEntity.state = 0;
        }else{
            senceEntity.state = 1;
        }
        
//        [self updateSenceDevice:senceEntity];
    }
}

-(IBAction)deviceSelectAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    BaseModel *baseModel = [_device_list objectAtIndex:but.tag];
    
    if ([baseModel isKindOfClass:[Entity class]]) {
        //    检测是否已经选择了
        BOOL isSelect = NO;
        int i=0;
        for (BaseModel *base in _selectDevice_list) {
            if ([((Entity *)baseModel).entityID isEqualToString:((SenceEntity *)base).entityId]) {
                isSelect = YES;
                break;
            }
            i++;
        }
        if (isSelect) {
            //            senceIndex不等于－1为修改
            if (_sence.senceIndex != -1)
//                [self removeSenceDevice:[_selectDevice_list objectAtIndex:i]];
            [_selectDevice_list removeObjectAtIndex:i];
        }else{
            SenceEntity *senceEntity = [[SenceEntity alloc] init];
            senceEntity.entityId = ((Entity *)baseModel).entityID;
            senceEntity.state = 0;
            [_selectDevice_list addObject:senceEntity];
            
//            senceIndex不等于－1为修改
//            if (_sence.senceIndex != -1) {
//                [self addSenceDevice:senceEntity];
//            }
        }
        [self.baseTableView reloadData];
    }else if ([baseModel isKindOfClass:[EntityRemote class]]){
     
        BOOL isSelect = NO;
        int i = 0;
        NSLog(@"selectDevice_list:%@",_selectDevice_list);
        for (BaseModel *base in _selectDevice_list) {
            if ([((EntityRemote *)baseModel).entityId isEqualToString:((SenceEntity *)base).entityId] && ((EntityRemote *)baseModel).entityRemoteIndex == ((SenceEntity *)base).entityRemoteIndex) {
                isSelect = YES;
                break;
            }
            i++;
        }
        
        if (isSelect) {
            if (_sence.senceIndex != -1) {
//                [self removeSenceDevice:[_selectDevice_list objectAtIndex:i]];
            }
            [_selectDevice_list removeObjectAtIndex:i];
        }else {
            EntityRemote *entityRemote = (EntityRemote *)baseModel;
            SenceEntity *senceEntity = [[SenceEntity alloc] init];
            senceEntity.entityId = entityRemote.entityId;
            senceEntity.entityRemoteIndex = entityRemote.entityRemoteIndex;
            senceEntity.state = 0;
            senceEntity.arcPower = entityRemote.arcPower;
            senceEntity.arcFan = entityRemote.arcFan;
            senceEntity.arcFanMode = entityRemote.arcFanMode;
            senceEntity.arcMode = entityRemote.arcMode;
            senceEntity.arcTemp = entityRemote.arcTemp;
            [_selectDevice_list addObject:senceEntity];
            
//            if (_sence.senceIndex != -1) {
//                [self addSenceDevice:senceEntity];
//            }
        }
        [self.baseTableView reloadData];
        
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
        
        BOOL isSelect = NO;
        int i = 0;
        for (BaseModel *base in _selectDevice_list) {
            if ([((EntityLine *)baseModel).entityID isEqualToString:((SenceEntity *)base).entityId] && [((EntityLine *)baseModel).entityLineNum intValue] == ((SenceEntity*)base).entityLineNum) {
                isSelect = YES;
                break;
            }
            i++;
        }
        
        if (isSelect) {
//            [self removeSenceDevice:[_selectDevice_list objectAtIndex:i]];
            //            senceIndex不等于－1为修改
            if (_sence.senceIndex != -1) {
                [_selectDevice_list removeObjectAtIndex:i];
            }
            
        }else {
            SenceEntity *senceEntity = [[SenceEntity alloc] init];
            senceEntity.entityId = ((EntityLine *)baseModel).entityID;
            senceEntity.state = 0;
            senceEntity.entityLineNum = [((EntityLine *)baseModel).entityLineNum intValue];
            [_selectDevice_list addObject:senceEntity];
            //            senceIndex不等于－1为修改
//            if (_sence.senceIndex != -1)
//                [self addSenceDevice:senceEntity];
        }
        [self.baseTableView reloadData];
    }
}

#pragma mark SenceAirEditDelegate
-(void)  eidtAirSence:(EntityRemote *)tempRemote
{
    [_entityRemoteProcess updateEntityRemote:tempRemote];

    for (SenceEntity *senceEntity in _selectDevice_list) {
        if ([senceEntity.entityId isEqualToString:tempRemote.entityId] && senceEntity.entityRemoteIndex == tempRemote.entityRemoteIndex) {
//            [self updateSenceDevice:senceEntity];
        }
    }
    [self.baseTableView reloadData];
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_device_list count];
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

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *baseModel = [_device_list objectAtIndex:indexPath.row];
    
    if ([baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)baseModel;
        EditSenceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditSenceDevice"
                                                                    forIndexPath:indexPath];
        SenceEntity *senceEntity = [self isKindSelect:entity];
        if (senceEntity == nil) {
            [cell.selectBut setSelected:NO];
        }else{
            [cell.selectBut setSelected:YES];
            if (senceEntity.state == 0) {
                [cell.deviceSwitch setOn:YES];
            }else{
                [cell.deviceSwitch setOn:NO];
            }
        }
        cell.deviceSwitch.tag = indexPath.row;
        cell.selectBut.tag = indexPath.row;
        [cell setBaseModel:entity];
        return cell;
        
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
        
        EntityLine *entityLine = (EntityLine *)baseModel;
        EditSenceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditSenceDevice"
                                                                    forIndexPath:indexPath];
        
        SenceEntity *senceEntity = [self isKindSelect:entityLine];
        
        if (senceEntity == nil) {
            [cell.selectBut setSelected:NO];
        }else {
            [cell.selectBut setSelected:YES];
            
            if (senceEntity.state == 0) {
                [cell.deviceSwitch setOn:YES];
            }else{
                [cell.deviceSwitch setOn:NO];
            }
        }
        cell.deviceSwitch.tag = indexPath.row;
        cell.selectBut.tag = indexPath.row;
        [cell setBaseModel:entityLine];
        return cell;
        
    }else{
        EntityRemote *entityRemote = (EntityRemote *)baseModel;
        EditSenceRemoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditSenceRemote"
                                                                    forIndexPath:indexPath];
        cell.selectBut.tag = indexPath.row;
        SenceEntity *senceEntity = [self isKindSelect:entityRemote];
        if (senceEntity == nil) {
            [cell.selectBut setSelected:NO];
        }else{
            [cell.selectBut setSelected:YES];
        }
        
        [cell.remoteImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:entityRemote.entityRemoteIcon]]];
        cell.remoteName.text = entityRemote.entityRemoteName;
        [cell setEntityRemote:entityRemote];
        
        return cell;
    }
}

//-(void) updateSenceDevice:(SenceEntity *)senceEntity
//{
//    NSString *msg = [NSString stringWithFormat:@"%d&%@&%d&%@&%d&%d&%d&%d&%d&%d&%d&%d",senceEntity.senceEntityIndex,BOX_ID_VALUE,_sence.senceIndex,senceEntity.entityId,senceEntity.entityLineNum,senceEntity.entityRemoteIndex,senceEntity.state,senceEntity.arcPower,senceEntity.arcMode,senceEntity.arcTemp,senceEntity.arcFan,senceEntity.arcFanMode];
//    
//    NSLog(@"msg:%@",msg);
//    [[Interface shareInterface:self] writeFormatDataAction:@"13" didMsg:msg didCallBack:^(NSString *code){
//        
//        NSLog(@"情景空调:%@",code);
//        
//    }];
//
//}

//-(void) addSenceDevice:(SenceEntity *)senceEntity
//{
//    NSString *msg = [NSString stringWithFormat:@"%@&%@&%d&%@&%d&%d&%d&%d&%d&%d&%d&%d",@"-1",BOX_ID_VALUE,_sence.senceIndex,senceEntity.entityId,senceEntity.entityLineNum,senceEntity.entityRemoteIndex,senceEntity.state,senceEntity.arcPower,senceEntity.arcMode,senceEntity.arcTemp,senceEntity.arcFan,senceEntity.arcFanMode];
//    [[Interface shareInterface:self] writeFormatDataAction:@"13" didMsg:msg didCallBack:^(NSString *code){
//        
//    }];
//}
//
//-(void) removeSenceDevice:(SenceEntity *)senceEntity
//{
//    NSString *msg = [NSString stringWithFormat:@"%@&%d",BOX_ID_VALUE,senceEntity.senceEntityIndex];
//    [[Interface shareInterface:self] writeFormatDataAction:@"14" didMsg:msg didCallBack:^(NSString *code) {
//        
//    }];
//}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.baseTableView reloadData];
    BaseModel *baseModel = [_device_list objectAtIndex:indexPath.row];
    
    if ([baseModel isKindOfClass:[Entity class]]) {
//    检测是否已经选择了
        BOOL isSelect = NO;
        int i=0;
        for (BaseModel *base in _selectDevice_list) {
            if ([((Entity *)baseModel).entityID isEqualToString:((SenceEntity *)base).entityId]) {
                isSelect = YES;
                break;
            }
            i++;
        }
        
        if (isSelect) {
//            senceIndex不等于－1为修改
            if (_sence.senceIndex != -1)
//            [self removeSenceDevice:[_selectDevice_list objectAtIndex:i]];
            [_selectDevice_list removeObjectAtIndex:i];
        }else{
            SenceEntity *senceEntity = [[SenceEntity alloc] init];
            senceEntity.entityId = ((Entity *)baseModel).entityID;
            senceEntity.state = 0;
            [_selectDevice_list addObject:senceEntity];
            
//            senceIndex不等于－1为修改
            if (_sence.senceIndex != -1) {
//                [self addSenceDevice:senceEntity];
            }
        }
        
        [self.baseTableView reloadData];
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
     
        BOOL isSelect = NO;
        int i = 0;
        for (BaseModel *base in _selectDevice_list) {
            if ([((EntityLine *)baseModel).entityID isEqualToString:((SenceEntity *)base).entityId] && [((EntityLine *)baseModel).entityLineNum intValue] == ((SenceEntity*)base).entityLineNum) {
                isSelect = YES;
                break;
            }
            i++;
        }
        
        if (isSelect) {
            [_selectDevice_list removeObjectAtIndex:i];
//            senceIndex不等于－1为修改
            if (_sence.senceIndex != -1) {
//                [self removeSenceDevice:[_selectDevice_list objectAtIndex:i]];
            }
        }else {
            SenceEntity *senceEntity = [[SenceEntity alloc] init];
            senceEntity.entityId = ((EntityLine *)baseModel).entityID;
            senceEntity.state = 0;
            senceEntity.entityLineNum = [((EntityLine *)baseModel).entityLineNum intValue];
            [_selectDevice_list addObject:senceEntity];
            //            senceIndex不等于－1为修改
//            if (_sence.senceIndex != -1)
//            [self addSenceDevice:senceEntity];
        }
        [self.baseTableView reloadData];
        
    }else{
        _currentIndex = indexPath.row;
        [self performSegueWithIdentifier:@"AirSettings" sender:nil];
    }
}

-(SenceEntity *) isKindSelect:(BaseModel *)baseModel
{
    for (BaseModel *base in _selectDevice_list) {
        
        if ([baseModel isKindOfClass:[Entity class]]) {
            if ([((Entity *)baseModel).entityID isEqualToString:((SenceEntity *)base).entityId]) {
                return (SenceEntity*)base;
            }
        }else if ([baseModel isKindOfClass:[EntityRemote class]]){
            
            if ([((EntityRemote *)baseModel).entityId isEqualToString: ((SenceEntity *)base).entityId] && ((EntityRemote *)baseModel).entityRemoteIndex == ((SenceEntity *)base).entityRemoteIndex) {
                return (SenceEntity*)base;
            }
        }else if ([baseModel isKindOfClass:[EntityLine class]]) {
            if ([((EntityLine *)baseModel).entityID isEqualToString:((SenceEntity *)base).entityId] && [((EntityLine *)baseModel).entityLineNum intValue] == ((SenceEntity *)base).entityLineNum) {
                return (SenceEntity *)base;
            }
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AirSettings"]) {
        SenceAirEditViewController *senceAir = segue.destinationViewController;
        senceAir.delegate = self;
        
        EntityRemote *entityRemote = (EntityRemote *)[_device_list objectAtIndex:_currentIndex];
        senceAir.entityRemote = entityRemote;
    }
}


@end
