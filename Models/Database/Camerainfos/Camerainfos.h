//
//  Camerainfos.h
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"
#import "FMDatabase.h"

@interface Camerainfos : BaseModel

@property (assign) int cameraIndex;
@property (nonatomic, strong) NSString *cameraNum;
@property (assign) int cameraState;
@property (nonatomic, strong) NSString *cameraName;
@property (nonatomic, strong) NSString *wifiName;
@property (nonatomic, strong) NSString *wifiPass;
@property (nonatomic, strong) NSString *boxId;

@property (nonatomic, strong) NSString *roomId;

@property (assign) int syncNum;

@end
