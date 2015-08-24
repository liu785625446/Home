//
//  Alarmphone.h
//  Home
//
//  Created by 刘军林 on 14-8-26.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"
#import "FMDatabase.h"

@interface Alarmphone : BaseModel

@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *contactNum;
@property (assign) int phoneIndex;
@property (nonatomic, strong) NSString *boxId;

-(id) initWithFMResultSet:(FMResultSet *)set;
@end
