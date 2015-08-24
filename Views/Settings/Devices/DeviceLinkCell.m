//
//  DeviceLineCell.m
//  Home
//
//  Created by 刘军林 on 14-5-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DeviceLinkCell.h"
#import "DeviceResource.h"
#import "EntityLine.h"

@implementation DeviceLinkCell

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

-(void) setEntity:(BaseModel *)entity
{
    [self.selectBut setImage:[UIImage imageNamed:@"cb_glossy_on.png"]
                    forState:UIControlStateSelected];
    
    NSLog(@"entity:%@",entity);
    
    if ([entity isKindOfClass:[Entity class]]) {
        
        Entity *entity1 = (Entity *)entity;
        self.deviceName.text = entity1.entityName;
        [self.deviceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:entity1.icon]]];
        self.deviceSwitch.hidden = YES;
        self.selectBut.selected = NO;;
        
    }else if ([entity isKindOfClass:[EntityLine class]]) {
        
        EntityLine *entityLine = (EntityLine *)entity;
        self.deviceName.text = entityLine.entityLineName;
        [self.deviceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:entityLine.icon]]];
        self.deviceSwitch.hidden = YES;
        self.selectBut.selected = NO;
        
    }
}

-(IBAction)setStateAction:(id)sender
{
    [_delegate setStateWithSender:sender];
}

-(void) setViewButAction:(BOOL)isHide
{
    self.selectBut.selected = isHide;
    self.deviceSwitch.hidden = !isHide;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
