//
//  MonitorCell.m
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MonitorCell.h"

@implementation MonitorCell

@synthesize monitorImg;
@synthesize monitorName;
@synthesize monitorBindBut;
@synthesize bangding;

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setName:(NSString *)name
{
    _name = name;
    self.monitorName.text = [NSString stringWithFormat:@"%@",_name];
}

-(IBAction)monitorBindAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    [_delegate monitorBindWithIndex:but.tag];
}

@end
