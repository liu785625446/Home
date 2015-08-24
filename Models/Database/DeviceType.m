//
//  DeviceType.m
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "DeviceType.h"

@implementation DeviceType

-(id) init
{
    if (self = [super init]) {
        _deviceList = [[NSMutableArray alloc] initWithCapacity:0];
        _deviceTypeTitle = @"";
        _currentStartRow = -1;
        _isOpen = NO;
        _deviceType = @"";
    }
    return self;
}

-(void) setDeviceType:(NSString *)deviceType
{
    _deviceType = deviceType;
    int code = [deviceType intValue];
    switch (code) {
        case 0:
            _deviceTypeTitle = @"插座";
            break;
        
        case 1:
            _deviceTypeTitle = @"多路面板";
            break;
            
        case 2:
            _deviceTypeTitle = @"窗帘";
            break;
            
        case 3:
            _deviceTypeTitle = @"红外遥控";
            break;
            
        case 4:
            _deviceTypeTitle = @"门磁";
            break;
            
        case 5:
            _deviceTypeTitle = @"红外探测";
            break;
            
        case 6:
            _deviceTypeTitle = @"燃气探测";
            break;
            
        case 7:
            _deviceTypeTitle = @"烟感";
            break;
            
        default:
            break;
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"DeviceType : { \n deviceTypeTItle:%@ \n _deviceList:%@ \n currentStartRow:%d \n isopen:%d \n deviceType:%@} \n ", _deviceTypeTitle, _deviceList, _currentStartRow, _isOpen, _deviceType];
}

@end
