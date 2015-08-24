//
//  AlarmPhoneProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AlarmPhoneProcess.h"
#import "AlarmphoneDao.h"
#import "Interface.h"
#import "Alarmphone.h"

@implementation AlarmPhoneProcess

-(id) init
{
    if (self = [super init]) {
        _alarmphoneDao = [AlarmphoneDao shareInstance];
    }
    return self;
}

-(void) synchronousAlarmPhone:(void (^)(int))success didFail:(void (^)(void))fail
{
    [_alarmphoneDao removeAllAlarmphone];
    [[Interface shareInterface:nil] writeFormatDataAction:@"65" didMsg:@"" didCallBack:^(NSString *code){
        NSLog(@"code:%@",code);
        if (code) {
            NSArray *tempArray = [code componentsSeparatedByString:@","];
            for (NSString *alarmphoneStr in tempArray) {
                NSArray *alarmphoneArray = [alarmphoneStr componentsSeparatedByString:@"@"];
                if ([alarmphoneArray count] == 2) {
                    Alarmphone *alarmphone = [[Alarmphone alloc] init];
                    alarmphone.contactNum = [alarmphoneArray objectAtIndex:0];
                    alarmphone.contactName = [alarmphoneArray objectAtIndex:1];
                    [_alarmphoneDao addAlarmphone:alarmphone];
                }
            }
            if ([tempArray count] > 1) {
                success([[tempArray objectAtIndex:1] intValue]);
            }else{
                fail();
            }
        }else{
            fail();
        }
    }];
}

-(NSMutableArray *) findAllAlarmphone
{
    return [_alarmphoneDao findAllAlarmphone];
}

@end
