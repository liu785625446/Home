//
//  AddDeviceCell.h
//  Home
//
//  Created by 刘军林 on 14-5-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"

@interface AddDeviceCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *deviceImg;
@property (nonatomic, strong) IBOutlet UILabel *deviceName;
@property (nonatomic, strong) IBOutlet UILabel *deviceInfo;

@property (nonatomic, strong) Entity *entity;

@property (nonatomic, strong) IBOutlet UIButton *addBut;

@end
