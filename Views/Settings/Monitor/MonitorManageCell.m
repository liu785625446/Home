//
//  MonitorManageCell.m
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MonitorManageCell.h"

@implementation MonitorManageCell

@synthesize monitorImg;
@synthesize monitorName;
@synthesize monitorInfo;
@synthesize monitorBut;

-(void) setCamerainfo:(Camerainfos *)camerainfo
{
    _camerainfo = camerainfo;
    self.monitorName.text = _camerainfo.cameraName;
    self.monitorInfo.text = _camerainfo.cameraName;
    self.monitorImg.layer.cornerRadius = self.monitorImg.frame.size.width/2;
}

@end
