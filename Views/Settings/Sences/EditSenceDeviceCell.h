//
//  EditSenceDeviceCell.h
//  Home
//
//  Created by 刘军林 on 14-5-12.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"

@interface EditSenceDeviceCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *selectBut;
@property (nonatomic, strong) IBOutlet UIImageView *deviceImg;
@property (nonatomic, strong) IBOutlet UILabel *deviceName;
@property (nonatomic, strong) IBOutlet UISwitch *deviceSwitch;

@property (nonatomic, strong) BaseModel *baseModel;

@end
