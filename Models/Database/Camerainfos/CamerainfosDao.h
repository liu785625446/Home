//
//  CamerainfosDao.h
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class Camerainfos;

@interface CamerainfosDao : BaseDao

+(CamerainfosDao *) shareInstance;

-(BOOL) addCamerainfos:(Camerainfos *)camerainfos;

-(BOOL) updateCamerainfos:(Camerainfos *)camerainfos;

-(BOOL) removeCamerainfos:(Camerainfos *)camerainfos;

-(NSMutableArray *) findAll;
-(NSMutableArray *)findById:(NSString *)cameraId;

-(Camerainfos *) findByCamerainfos:(Camerainfos *)camerainfos;

-(NSMutableArray *) findByKey:(NSString *)key;

@end
