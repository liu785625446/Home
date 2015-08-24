//
//  AddDeviceCell.m
//  Home
//
//  Created by 刘军林 on 14-5-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddDeviceCell.h"
#import "DeviceResource.h"

@implementation AddDeviceCell

@synthesize deviceImg;
@synthesize deviceName;
@synthesize deviceInfo;

@synthesize addBut;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setEntity:(Entity *)entity
{
    _entity = entity;
    
    [self.deviceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:_entity.icon]]];
    self.deviceName.text = _entity.entityName;
    self.deviceInfo.text = _entity.entityName;
    
    if ([entity.entityType intValue] == AP_TYPE) {
        [self.deviceImg setImage:[UIImage imageNamed:@"icon_ap.png"]];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
