//
//  BaseDao.h
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BaseModel;
@class DBHelper;
@class FMResultSet;

@interface BaseDao : NSObject

@property (strong, nonatomic) DBHelper *dbHelper;

-(BOOL) executeUpdate:(NSString *)sql;
-(NSMutableArray *) executeQuery:(NSString *)sql;

-(BaseModel *) objectForSet:(FMResultSet *)set;

@end
