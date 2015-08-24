//
//  MDeviceAirView.h
//  Home
//
//  Created by 刘军林 on 15/8/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAILSTAG 60
#define MODELTAG 63
#define WINDTAG 64
#define TEMPERATUREADDTAG 61
#define TEMPERATUREMINUSTAG 62
#define SWEPTTAG 65

@interface MDeviceAirView : UIView

@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *brandGroupIndex;

@end
