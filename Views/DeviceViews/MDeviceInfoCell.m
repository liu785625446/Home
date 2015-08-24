//
//  MDeviceInfoCell.m
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceInfoCell.h"

#import "Entity.h"
#import "EntityLine.h"
#import "EntityLink.h"
#import "EntityRemote.h"
#import "DeviceResource.h"

@implementation MDeviceInfoCell

-(void) setBaseModel:(BaseModel *)baseModel
{
    _baseModel = baseModel;
    
    self.accessoryType = UITableViewCellAccessoryNone;

    if ([_baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)_baseModel;
        
        _deviceName.text = entity.entityName;
        if (entity.state == 0) {
            _deviceStatus.text = @"开启";
            _deviceImg.image = [UIImage imageNamed:[DeviceResource getOpenImage:entity.icon]];
        }else if(entity.state == 1) {
            _deviceStatus.text = @"关闭";
            _deviceImg.image = [UIImage imageNamed:[DeviceResource getCloseImage:entity.icon]];
        }else if(entity.state == 2) {
            _deviceStatus.text = @"停止";
            _deviceImg.image = [UIImage imageNamed:[DeviceResource getCloseImage:entity.icon]];
        }else if (entity.state == 3) {
            _deviceStatus.text = @"请重试";
        }
        if ([entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == SMKEN || [entity.entityType intValue] == INFRARED_PROBE) {
            if (entity.power > 30) {
                [self.deviceBatteryImg setImage:[UIImage imageNamed:@"batteryfull.png"]];
            }else if (entity.power > 28 && entity.power <= 30) {
                [self.deviceBatteryImg setImage:[UIImage imageNamed:@"battery75.png"]];
            }else if (entity.power > 25 && entity.power <= 28 ) {
                [self.deviceBatteryImg setImage:[UIImage imageNamed:@"battery50.png"]];
            }else if (entity.power > 23 && entity.power <= 25) {
                [self.deviceBatteryImg setImage:[UIImage imageNamed:@"battery25.png"]];
            }else {
                [self.deviceBatteryImg setImage:[UIImage imageNamed:@"batterylow.png"]];
            }
        }else {
            [self.deviceBatteryImg setImage:[UIImage imageNamed:@""]];
        }
        
    }else if ([_baseModel isKindOfClass:[EntityLine class]]) {
        EntityLine *entityLine = (EntityLine *)_baseModel;
        
        _deviceName.text = entityLine.entityLineName;
        if (entityLine.state == 0) {
            _deviceStatus.text = @"开启";
            _deviceImg.image = [UIImage imageNamed:[DeviceResource getOpenImage:entityLine.icon]];
        }else if(entityLine.state == 1){
            _deviceStatus.text = @"关闭";
            _deviceImg.image = [UIImage imageNamed:[DeviceResource getCloseImage:entityLine.icon]];
        }else if (entityLine.state == 3) {
            _deviceStatus.text = @"请重试";
        }
        [self.deviceBatteryImg setImage:[UIImage imageNamed:@""]];
    }else if ([_baseModel isKindOfClass:[EntityRemote class]]) {
        
        EntityRemote *entityRemote = (EntityRemote *)_baseModel;
        
        _deviceName.text = entityRemote.entityRemoteName;
        _deviceStatus.text = entityRemote.entityRemoteName;
        _deviceImg.image = [UIImage imageNamed:[DeviceResource getOpenImage:entityRemote.entityRemoteIcon]];
        [self.deviceBatteryImg setImage:[UIImage imageNamed:@""]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
