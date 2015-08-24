//
//  DBHelper.h
//  Home
//
//  Created by 刘军林 on 14/11/17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface DBHelper : NSObject
{

}
@property (nonatomic, strong) FMDatabaseQueue *db_queue;

+(DBHelper *) shareDBHelper;

//获取沙箱Document目录下全路径
+(NSString *) applicationDocumentsDirectoryFile: (NSString *)fileName;

//初始化并加载数据
-(void) initDB;

/**
 *  从数据库返回版本
 *
 *  @return 数据库版本号
 */
-(int) dbVersionNumber;

@end
