//
//  CamerainfosProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CamerainfosDao;
@class Camerainfos;

@interface CamerainfosProcess : NSObject
{
    NSLock *lock;
}

@property (nonatomic, strong) CamerainfosDao *camerainfosDao;

-(void) synchronousCamerainfos:(void (^) (void))success didFail:(void (^) (void))fail;

-(NSMutableArray *) findAllCameraInfos;
-(Camerainfos *) findCameraInfosForId:(NSString *)cameraId;

-(BOOL) removeCamerainfos:(Camerainfos *)camerainfos;
@end
