//
//  SenceEntityProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SenceEntityDao;
@class Sence;
@class BaseModel;

@interface SenceEntityProcess : NSObject

@property (nonatomic, strong) SenceEntityDao *senceEntityDao;

-(void) synchronousSenceEntity:(Sence *)sence didSuccess:(void (^) (void)) success didFail:(void (^) (void)) fail;

-(NSMutableArray *) findSenceEntityForSence:(Sence *)sence;

//-(BOOL) removeSenceEntityForBaseModel:(BaseModel *)baseModel;
@end
