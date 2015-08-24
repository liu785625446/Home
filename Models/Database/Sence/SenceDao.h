//
//  SenceDao.h
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class Sence;

@interface SenceDao : BaseDao

+(SenceDao *)shareInstance;

-(BOOL) addSence:(Sence *)sence;

-(BOOL) updateSence:(Sence *)sence;

-(BOOL) removeSence:(Sence *)sence;

-(NSMutableArray *) findAll;

-(NSMutableArray *) findByKey:(NSString *)key;

-(Sence *) findBySence:(Sence *)sence;

@end
