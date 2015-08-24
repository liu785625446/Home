//
//  EntityLink.h
//  Home
//
//  Created by 刘军林 on 14-8-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"

@interface EntityLink : BaseModel

@property (assign) int tableid;
@property (nonatomic, strong) NSString *safeEntityId;    //安防设备ID
@property (nonatomic, strong) NSString *entityId;        //联动设备ID
@property (assign) int entityLineNum;
//state 0为开 其余为关
@property (assign) int state;
@property (assign) int entityLinkIndex;

@end
