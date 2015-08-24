//
//  CamerainfosDao.m
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "CamerainfosDao.h"
#import "Camerainfos.h"
#import "DBHelper.h"
#import "FMDatabase.h"

static CamerainfosDao *shareCamerainfosDao;

@implementation CamerainfosDao

+(CamerainfosDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareCamerainfosDao) {
            shareCamerainfosDao = [[CamerainfosDao alloc] init];
            [CamerainfosDao createTable];
        }
    });
    return shareCamerainfosDao;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE if not exists cameraInfos (tableid INTEGER PRIMARY KEY, cameraIndex INTEGER, cameraNum TEXT, cameraState INTEGER, cameraName TEXT, wifiName TEXT, wifiPass TEXT, boxId TEXT, syncNum INTEGER, roomId TEXT)";
    return [shareCamerainfosDao executeUpdate:sql];
}

-(BOOL) addCamerainfos:(Camerainfos *)camerainfos
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO cameraInfos (cameraIndex, cameraNum, cameraState, cameraName, wifiName, wifiPass, boxId, syncNum, roomId) VALUES (%d, '%@', %d, '%@', '%@', '%@', '%@', %d, '%@')",camerainfos.cameraIndex, camerainfos.cameraNum, camerainfos.cameraState, camerainfos.cameraName, camerainfos.wifiName, camerainfos.wifiPass, camerainfos.boxId, camerainfos.syncNum, camerainfos.roomId];
    return [self executeUpdate:sql];
}

-(BOOL) updateCamerainfos:(Camerainfos *)camerainfos
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE cameraInfos SET cameraState = %d, cameraName = '%@', wifiName = '%@', wifiPass = '%@', syncNum = %d, roomId = '%@' where cameraIndex = %d AND cameraNum = '%@' AND boxId = '%@'",camerainfos.cameraState, camerainfos.cameraName, camerainfos.wifiName, camerainfos.wifiPass, camerainfos.syncNum,camerainfos.roomId, camerainfos.cameraIndex, camerainfos.cameraNum, BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(BOOL) removeCamerainfos:(Camerainfos *)camerainfos
{
    NSString *sql = [NSString stringWithFormat:@"delete from cameraInfos where cameraIndex = %d AND cameraNum = '%@' AND boxId = '%@'",camerainfos.cameraIndex, camerainfos.cameraNum, BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from cameraInfos where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(NSMutableArray *)findById:(NSString *)cameraId
{
    NSString *sql = [NSString stringWithFormat:@"select * from cameraInfos where boxId = '%@' AND cameraNum = '%@'",BOX_ID_VALUE, cameraId];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findByKey:(NSString *)key
{
    NSString *sql = @"";
    if ([key isEqualToString:@""]) {
        sql = [NSString stringWithFormat:@"select * from cameraInfos where boxId = '%@'", BOX_ID_VALUE];
    }else {
        sql = [NSString stringWithFormat:@"select * from cameraInfos where %@ AND boxId = '%@'",key, BOX_ID_VALUE];
    }
    return [self executeQuery:sql];
}

-(Camerainfos *) findByCamerainfos:(Camerainfos *)camerainfos
{
    NSString *sql = [NSString stringWithFormat:@"select * from cameraInfos where boxId = '%@' AND cameraNum = '%@'", BOX_ID_VALUE, camerainfos.cameraNum];
    NSMutableArray *camerainfos_list = [self executeQuery:sql];
    if ([camerainfos_list count] > 0) {
        return [camerainfos_list objectAtIndex:0];
    }
    return nil;
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    Camerainfos *camerainfos = [[Camerainfos alloc] init];
    camerainfos.cameraIndex = [set intForColumn:@"cameraIndex"];
    camerainfos.cameraNum = [set stringForColumn:@"cameraNum"];
    camerainfos.cameraState = [set intForColumn:@"cameraState"];
    camerainfos.cameraName = [set stringForColumn:@"cameraName"];
    camerainfos.wifiName = [set stringForColumn:@"wifiName"];
    camerainfos.wifiPass = [set stringForColumn:@"wifiPass"];
    camerainfos.syncNum = [set intForColumn:@"syncNum"];
    camerainfos.roomId = [set stringForColumn:@"roomId"];
    camerainfos.boxId = BOX_ID_VALUE;
    return camerainfos;
}

@end
