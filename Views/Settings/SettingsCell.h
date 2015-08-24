//
//  SettingsCell.h
//  Home
//
//  Created by 刘军林 on 14-5-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UISwitch *switchBut;
@property (nonatomic, weak) IBOutlet UIImageView *img;
@property (nonatomic, weak) IBOutlet UILabel *title;

@end
