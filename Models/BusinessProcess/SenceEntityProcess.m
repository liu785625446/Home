//
//  SenceEntityProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceEntityProcess.h"
#import "SenceEntityDao.h"
#import "Sence.h"
#import "Interface.h"
#import "FMDatabase.h"
#import "SenceEntity.h"

@implementation SenceEntityProcess

-(id) init
{
    if (self = [super init]) {
        _senceEntityDao = [SenceEntityDao shareInstance];
    }
    return self;
}

-(void) synchronousSenceEntity:(Sence *)sence didSuccess:(void (^)(void))success didFail:(void (^)(void))fail
{
//    删除所有当前情景设备
    [_senceEntityDao removeAllForSence:sence];
    
    NSString *msg = [NSString stringWithFormat:@"%@&%d",BOX_ID_VALUE, sence.senceIndex];
    [[Interface shareInterface:nil] writeFormatDataAction:@"67" didMsg:msg didCallBack:^(NSString *code){
        if (code) {
            NSLog(@"%@",code);
            NSArray *tempArray = [code componentsSeparatedByString:@"&"];
            NSString *senceIndex = @"";
            if ([tempArray count] == 3) {
                senceIndex = [tempArray objectAtIndex:1];
                tempArray = [[tempArray objectAtIndex:2] componentsSeparatedByString:@","];
                if ([tempArray count] > 0) {
                    for (NSString *senceEntityStr  in tempArray) {
                        NSLog(@"senceEntityStr:%@",senceEntityStr);
                        NSArray *senceEntityArray = [senceEntityStr componentsSeparatedByString:@"@"];
                        if ([senceEntityArray count] == 10) {
                            SenceEntity *senceEntity = [[SenceEntity alloc] init];
                            senceEntity.senceIndex = [senceIndex intValue];
                            senceEntity.senceEntityIndex = [[senceEntityArray objectAtIndex:0] intValue];
                            senceEntity.entityId = [senceEntityArray objectAtIndex:1];
                            senceEntity.entityLineNum = [[senceEntityArray objectAtIndex:2] intValue];
                            senceEntity.entityRemoteIndex = [[senceEntityArray objectAtIndex:3] intValue];
                            senceEntity.state = [[senceEntityArray objectAtIndex:4] intValue];
                            senceEntity.arcPower = [[senceEntityArray objectAtIndex:5] intValue];
                            senceEntity.arcMode = [[senceEntityArray objectAtIndex:6] intValue];
                            senceEntity.arcTemp = [[senceEntityArray objectAtIndex:7] intValue];
                            senceEntity.arcFan = [[senceEntityArray objectAtIndex:8] intValue];
                            senceEntity.arcFanMode = [[senceEntityArray objectAtIndex:9] intValue];
                            senceEntity.boxId = BOX_ID_VALUE;
                            [_senceEntityDao addSenceEntity:senceEntity];
                        }
                    }
                    success();
                }else{
                    fail();
                }
            }
        }else{
            fail();
        }
    }];
}

//-(BOOL) removeSenceEntityForBaseModel:(BaseModel *)baseModel
//{
//    return [_senceEntityDao removeSenceEntityForBaseModel:baseModel];
//}

-(NSMutableArray *) findSenceEntityForSence:(Sence *)sence
{
    return [_senceEntityDao findSenceEntityForSence:sence];
}

@end
