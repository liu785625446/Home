//
//  EditDeviceCell.h
//  Home
//
//  Created by 刘军林 on 14-5-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"
#import "EntityRemote.h"
#import "EntityLine.h"

@interface DeviceImgCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *deviceName;
@property (nonatomic, strong) IBOutlet UIImageView *deviceImg;

@property (nonatomic, strong) Entity *entity;

@end


@interface DeviceEditTitleCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *deviceName;
@property (nonatomic, strong) IBOutlet UIButton *updateBut;

@property (nonatomic, strong) BaseModel *entity;

@end

@interface DeviceEditImgCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *deviceImg;

@property (nonatomic, strong) EntityLine *entityLine;

@end

@interface StartLinkCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UISwitch *startLinkBut;
@property (nonatomic, strong) Entity *entity;

@end

@interface RemoteCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *remote_Img;
@property (nonatomic, strong) IBOutlet UILabel *remote_Name;
@property (nonatomic, strong) EntityRemote *entityRemote;

@end
