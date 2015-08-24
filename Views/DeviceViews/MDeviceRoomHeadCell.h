//
//  MDeviceRoomCell.h
//  Home
//
//  Created by 刘军林 on 15/4/23.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"

@class MDeviceRoomHeadCell;
@protocol MDeviceRoomHeadCellDelegate <NSObject>

-(void) MDeviceRoomHead:(MDeviceRoomHeadCell *)roomHead didSelectSection:(NSInteger)section;

@end

@interface MDeviceRoomHeadCell : UIView

@property (nonatomic, strong) IBOutlet UILabel *roomName;
@property (nonatomic, strong) IBOutlet UIImageView *downImg;
@property (nonatomic, strong) IBOutlet UILabel *roomAmount;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) id <MDeviceRoomHeadCellDelegate> delegate;

@end
