//
//  MNewRemoteSearchViewController.h
//  Home
//
//  Created by 刘军林 on 15/8/19.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseViewController.h"

@class MNewDeviceType;
@class MNewBrand;

@interface MNewRemoteSearchViewController : MBaseViewController

@property (nonatomic, strong) MNewDeviceType *deviceType;
@property (nonatomic, strong) MNewBrand *brand;

@property (nonatomic, strong) NSString *entityId;

@end
