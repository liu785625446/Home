//
//  EditSenceDeviceCell.m
//  Home
//
//  Created by 刘军林 on 14-5-12.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EditSenceDeviceCell.h"
#import "DeviceResource.h"
#import "EntityLine.h"

@implementation EditSenceDeviceCell

@synthesize selectBut;
@synthesize deviceImg;
@synthesize deviceName;
@synthesize deviceSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void) setBaseModel:(BaseModel *)baseModel
{
    _baseModel = baseModel;
    
    if ([_baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)_baseModel;
        
        [self.deviceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:entity.icon]]];
        self.deviceName.text = entity.entityName;

    }else if ([_baseModel isKindOfClass:[EntityLine class]]) {
        
        EntityLine *entityline = (EntityLine *)_baseModel;
        
        [self.deviceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:entityline.icon]]];
        self.deviceName.text = entityline.entityLineName;
        
    }

    [self.selectBut setImage:[UIImage imageNamed:@"cb_glossy_on.png"]
                    forState:UIControlStateSelected];
    if (self.selectBut.selected) {
        self.deviceSwitch.hidden = NO;
    }else{
        self.deviceSwitch.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
