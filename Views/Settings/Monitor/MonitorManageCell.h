//
//  MonitorManageCell.h
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camerainfos.h"

@interface MonitorManageCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *monitorImg;
@property (nonatomic, strong) IBOutlet UILabel *monitorName;
@property (nonatomic, strong) IBOutlet UILabel *monitorInfo;
@property (nonatomic, strong) IBOutlet UIButton *monitorBut;

@property (nonatomic, strong) Camerainfos *camerainfo;

@end
