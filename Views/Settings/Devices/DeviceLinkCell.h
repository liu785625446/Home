//
//  DeviceLineCell.h
//  Home
//
//  Created by 刘军林 on 14-5-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"

@protocol DeviceLinkCellDelegate <NSObject>

-(void) setStateWithSender:(id)sender;

@end



@interface DeviceLinkCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *selectBut;
@property (nonatomic, strong) IBOutlet UIImageView *deviceImg;
@property (nonatomic, strong) IBOutlet UILabel *deviceName;
@property (nonatomic, strong) IBOutlet UISwitch *deviceSwitch;

@property (nonatomic, strong) BaseModel *entity;

@property (nonatomic, weak) id<DeviceLinkCellDelegate> delegate;

-(IBAction)setStateAction:(id)sender;

-(void) setViewButAction:(BOOL) isHide;

@end
