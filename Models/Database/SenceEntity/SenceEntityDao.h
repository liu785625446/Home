//
//  SenceEntityDao.h
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class SenceEntity;
@class Sence;

@interface SenceEntityDao : BaseDao

+(SenceEntityDao *)shareInstance;

-(BOOL) addSenceEntity:(SenceEntity *)senceEntity;

-(BOOL) updateSenceEntity:(SenceEntity *)senceEntity;

-(BOOL) removeSenceEntity:(SenceEntity *)senceEntity;

-(BOOL) removeAllForSence:(Sence *)sence;

-(BOOL) removeSenceEntityForBaseModel:(BaseModel *)baseModel;

-(NSMutableArray *) findSenceEntityForSence:(Sence *)sence;

@end
