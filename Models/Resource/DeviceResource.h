//
//  DeviceResource.h
//  Home
//
//  Created by 刘军林 on 14-7-25.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceResource : NSObject

@property (nonatomic, strong) NSString *device_name;
@property (nonatomic, strong) NSString *default_icon;
@property (nonatomic, strong) NSString *open_icon;
@property (nonatomic, strong) NSString *close_icon;
@property (assign) int icon_tag;

+(NSString *) getDefaultImage:(int)index;
+(NSString *)getOpenImage:(int)index;
+(NSString *) getCloseImage:(int)index;

+(NSString *) getDeviceDefaultName:(int)index;
+(NSString *) getDeviceDefaultImg:(int)index;
+(DeviceResource *) objectForIndex:(int )index;

@end
