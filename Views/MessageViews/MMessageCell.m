//
//  MMessageCell.m
//  Home
//
//  Created by 刘军林 on 15/4/21.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MMessageCell.h"
#import "AlarmInfos.h"
#import "Tool.h"

@implementation MMessageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setAlarmInfo:(AlarmInfos *)alarmInfo
{
    _alarmInfo = alarmInfo;
//    _msgTime.text = [NSString stringWithFormat:@"%@ %@",[Tool getDateForTimeIntervale:_alarmInfo.alarmTime/1000],[Tool getTimeForTimeIntervale:_alarmInfo.alarmTime/1000]];
    
    _msgTime.text = [Tool getDate:[NSString stringWithFormat:@"%@ %@:00",[Tool getDateForTimeIntervale:_alarmInfo.alarmTime/1000],[Tool getTimeForTimeIntervale:_alarmInfo.alarmTime/1000]]];
    
//    _msgTime.text = [NSString stringWithFormat:@"%@    %@ %@",_msgTime.text, [Tool getDateForTimeIntervale:_alarmInfo.alarmTime/1000],[Tool getTimeForTimeIntervale:_alarmInfo.alarmTime/1000]];
//    _msgTime.text = [NSString stringWithFormat:@"%@"]
    
    _msgContent.text = [NSString stringWithFormat:@"强先生提醒您: %@设备发生了[触发]信息，可能是家里存在安全隐患，请及时处理",_alarmInfo.entityName];
}

@end
