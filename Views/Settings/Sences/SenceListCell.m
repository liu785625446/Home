//
//  SenceListCell.m
//  Home
//
//  Created by 刘军林 on 14-5-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceListCell.h"
#import "DeviceResource.h"
#import "Tool.h"
#import "Sence.h"
#import "config.h"

@implementation SenceListCell

@synthesize senceImg;
@synthesize senceName;
@synthesize senceInfo;
@synthesize senceTimeInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void) setSence:(Sence *)sence
{
    _sence = sence;
    
    [self.senceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:_sence.senceIcon]]];
    self.senceName.text = _sence.senceName;
    
    if (_sence.senceType == SENCE_TYPE_DELAY) { //延时启动
        
        if (_sence.delayTime == 0) {
            self.senceInfo.text = @"立即启动";
        }else if (_sence.delayTime == 1) {
            self.senceInfo.text = @"延时30秒启动";
        }else if (_sence.delayTime == 2) {
            self.senceInfo.text = @"延时1分钟启动";
        }else if (_sence.delayTime == 3) {
            self.senceInfo.text = @"延时2分钟启动";
        }else{
            self.senceInfo.text = @"延时5分钟启动";
        }
        
    }else if (_sence.senceType == SENCE_TYPE_TIMING) { //一次性定时
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeInterval = date.timeIntervalSince1970;
        if (timeInterval>_sence.senceTime) {
            self.senceInfo.text = @"定时情景已过期";
        }else{
            self.senceInfo.text = [NSString stringWithFormat:@"%@ %@启动",[Tool getDateForTimeIntervale:_sence.senceDate], [Tool getTimeForTimeIntervale:_sence.senceTime]];
        }
        
    }else { //周期定时
        
        if (_sence.senceWeek == 0) {
            self.senceInfo.text = @"永不";
        }else{
            self.senceInfo.text = [NSString stringWithFormat:@"%@ %@启动",[self getWeekStr:_sence.senceWeek],[Tool getTimeForTimeIntervale:_sence.senceTime]];
        }
    }

    if (_sence.lastStartTime <=1) {
        NSLog(@"%lld，，，%@",_sence.createTime,_sence);
        self.senceTimeInfo.text = [NSString stringWithFormat:@"创建时间:%@ %@",[Tool getDateForTimeIntervale:_sence.createTime], [Tool getTimeForTimeIntervale:_sence.createTime]];
    }else{
        self.senceTimeInfo.text = [NSString stringWithFormat:@"最后启动时间:%@ %@",[Tool getDateForTimeIntervale:_sence.lastStartTime], [Tool getTimeForTimeIntervale:_sence.lastStartTime]];
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
        weekStr = [NSString stringWithFormat:@"周%@日",weekStr];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
