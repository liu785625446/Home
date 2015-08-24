//
//  ContactCell.m
//  Home
//
//  Created by 刘军林 on 14-5-20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell
@synthesize name;
@synthesize phone;

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

@end
