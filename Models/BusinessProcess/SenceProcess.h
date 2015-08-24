//
//  SenceProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SenceDao;

@interface SenceProcess : NSObject
{
    NSLock *lock;
}

@property (nonatomic, strong) SenceDao *senceDao;

-(void) synchronousSence:(void (^)(void))success didFail:(void (^)(void))fail;

-(NSMutableArray *)findAllSence;
@end
