//
//  MonitorEidtCell.h
//  Home
//
//  Created by 刘军林 on 14-9-24.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorNameCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *monitorName;
@property (nonatomic, strong) IBOutlet UIButton *monitorEdit;

@end


@interface MonitorQualityCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;

@end


@interface MonitorWifiCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UISwitch *monitorSwitch;

@end