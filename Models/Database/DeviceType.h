//
//  DeviceType.h
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "BaseModel.h"

@interface DeviceType : BaseModel

@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *deviceTypeTitle;

@property (nonatomic, strong) NSMutableArray *deviceList;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSInteger currentStartRow;

@end
