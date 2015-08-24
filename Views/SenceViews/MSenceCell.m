//
//  MSenceCell.m
//  Home
//
//  Created by 刘军林 on 15/4/21.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MSenceCell.h"
#import "Sence.h"
#import "Tool.h"
#import "DeviceResource.h"

@implementation MSenceCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setSence:(Sence *)sence
{
    _sence = sence;
    
    [_senceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:_sence.senceIcon]]];
    _senceImg.layer.cornerRadius = _senceImg.frame.size.width/2;
    _senceName.text = _sence.senceName;
    
    if (_sence.senceType == SENCE_TYPE_DELAY) {
        if (_sence.delayTime == 0) {
            _senceStartMode.text = @"立即启动";
        }else if (_sence.delayTime == 1) {
            _senceStartMode.text = @"延时30秒启动";
        }else if (_sence.delayTime == 2) {
            _senceStartMode.text = @"延时1分钟启动";
        }else if (_sence.delayTime == 3) {
            _senceStartMode.text = @"延时2分钟启动";
        }else{
            _senceStartMode.text = @"延时5分钟启动";
        }
        
    }else if (_sence.senceType == SENCE_TYPE_TIMING) //一次性定时
    {
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval = date.timeIntervalSince1970;
        if (timeInterval>_sence.senceTime) {
            _senceStartMode.text = @"定时情景已过期";
        }else{
            _senceStartMode.text = [NSString stringWithFormat:@"%@ %@启动",[Tool getDateForTimeIntervale:_sence.senceDate], [Tool getTimeForTimeIntervale:_sence.senceTime]];
        }
    }else {
        if (_sence.senceWeek == 0) {
            _senceStartMode.text = @"永不";
        }else{
            _senceStartMode.text = [NSString stringWithFormat:@"%@ %@启动",[self getWeekStr:_sence.senceWeek],[Tool getTimeForTimeIntervale:_sence.senceTime]];
        }
    }
    
    if (_sence.lastStartTime <=1) {
        NSLog(@"%lld，，，%@",_sence.createTime,_sence);
        _senceLastStartTime.text = [NSString stringWithFormat:@"创建时间:%@ %@",[Tool getDateForTimeIntervale:_sence.createTime], [Tool getTimeForTimeIntervale:_sence.createTime]];
    }else{
        NSLog(@"%lld，，，%@",_sence.createTime,_sence);
        _senceLastStartTime.text = [NSString stringWithFormat:@"最后启动时间:%@ %@",[Tool getDateForTimeIntervale:_sence.lastStartTime], [Tool getTimeForTimeIntervale:_sence.lastStartTime]];
    }
}


-(NSString *) getWeekStr:(int )senceWeek
{
    NSString *weekStr = @"";
    
    //    每天
    if (senceWeek == (SUNDAY + MONDAY + TUESDAY + WEDNESDAY + THURSDAY + FRIDAY + SATURDAY)) {
        return weekStr = @"每天";
    }
    
    if (senceWeek == (MONDAY + TUESDAY + WEDNESDAY + THURSDAY + FRIDAY)) {
        return weekStr = @"工作日";
    }
    
    if ((senceWeek & SUNDAY) == SUNDAY) {
        weekStr = [NSString stringWithFormat:@"%@日",weekStr];
    }
    
    if ((senceWeek & MONDAY) == MONDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 一",weekStr];
    }
    
    if ((senceWeek & TUESDAY) == TUESDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 二",weekStr];
    }
    
    if ((senceWeek & WEDNESDAY) == WEDNESDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 三",weekStr];
    }
    
    if ((senceWeek & THURSDAY) == THURSDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 四",weekStr];
    }
    
    if ((senceWeek & FRIDAY) == FRIDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 五",weekStr];
    }
    
    if ((senceWeek & SATURDAY) == SATURDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 六",weekStr];
    }
    
    if ([weekStr isEqualToString:@""]) {
        weekStr = @"永不";
    }
    
    return weekStr;
}

@end

@implementation MSenceMusicCell



@end