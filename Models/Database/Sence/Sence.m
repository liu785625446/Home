//
//  Sence.m
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "Sence.h"

@implementation Sence

@synthesize tableid;
@synthesize senceName;
@synthesize senceIcon;
@synthesize senceType;
@synthesize delayTime;
@synthesize senceDate;
@synthesize senceTime;
@synthesize senceWeek;
@synthesize lastStartTime;
@synthesize createTime;
@synthesize senceIndex;
@synthesize boxId;
@synthesize syncNum;

@synthesize senceEntityList;

-(id) init
{
    self = [super init];
    if (self) {
        self.tableid = 0;
        self.senceName = @"";
        self.senceIcon = 0;
        self.senceType = 0;
        self.delayTime = 0;
        
        self.senceDate = [[NSDate date] timeIntervalSince1970];
        self.senceTime = [[NSDate date] timeIntervalSince1970];
        self.senceWeek = 0;
        self.lastStartTime = 0;
        self.createTime = 0;
        self.senceIndex = 0;
        self.boxId = @"";
        self.syncNum = 0;
        self.senceMusic = @"";
        self.senceEntityList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(NSString *) getWeekStr
{
    NSString *weekStr = @"";
    
//    每天
    if (self.senceWeek == (SUNDAY + MONDAY + TUESDAY + WEDNESDAY + THURSDAY + FRIDAY + SATURDAY)) {
        return weekStr = @"每天";
    }
    
    if (self.senceWeek == (MONDAY + TUESDAY + WEDNESDAY + THURSDAY + FRIDAY)) {
        return weekStr = @"工作日";
    }
    
    if ((self.senceWeek & SUNDAY) == SUNDAY) {
        weekStr = [NSString stringWithFormat:@"%@周日",weekStr];
    }
    
    if ((self.senceWeek & MONDAY) == MONDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 周一",weekStr];
    }
    
    if ((self.senceWeek & TUESDAY) == TUESDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 周二",weekStr];
    }
    
    if ((self.senceWeek & WEDNESDAY) == WEDNESDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 周三",weekStr];
    }
    
    if ((self.senceWeek & THURSDAY) == THURSDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 周四",weekStr];
    }
    
    if ((self.senceWeek & FRIDAY) == FRIDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 周五",weekStr];
    }
    
    if ((self.senceWeek & SATURDAY) == SATURDAY) {
        weekStr = [NSString stringWithFormat:@"%@ 周六",weekStr];
    }
    
    if ([weekStr isEqualToString:@""]) {
        weekStr = @"永不";
    }
    
    return weekStr;
}
@end
