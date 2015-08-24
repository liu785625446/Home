//
//  MDeviceInfoCell.h
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"
#import "BaseModel.h"

@interface MDeviceInfoCell : MBaseTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *deviceImg;
@property (nonatomic, weak) IBOutlet UILabel *deviceName;
@property (nonatomic, weak) IBOutlet UIImageView *deviceBatteryImg;
@property (nonatomic, weak) IBOutlet UILabel *deviceStatus;

@property (nonatomic, weak) IBOutlet UIImageView *upImg;

@property (nonatomic, strong) BaseModel *baseModel;

@end
