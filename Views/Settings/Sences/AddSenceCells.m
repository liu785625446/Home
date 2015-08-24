//
//  AddSenceCells.m
//  Home
//
//  Created by 刘军林 on 14-5-9.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddSenceCells.h"
#import "SEFilterControl.h"

@implementation SenceNameCell

@synthesize senceName;


@end

@implementation SenceSelectCell


@end

@implementation SenceImgCell

@synthesize senceImg;


@end


@implementation SenceSwitchCell

@synthesize senceLabel;
@synthesize senceSwitch;


@end


@implementation SenceLabelCell

@synthesize senceKey;
@synthesize senceValue;



@end

@implementation SenceSliderCell
@synthesize filter;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
         filter = [[SEFilterControl alloc] initWithFrame:CGRectMake(90, 0, 220, 60) Titles:@[@"0秒",@"30秒",@"1分钟",@"2分钟",@"5分钟"]];
        [filter setTitlesFont:[UIFont systemFontOfSize:12]];
        [filter addTarget:self
                   action:@selector(filterValueChanged:)
         forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:filter];
    }
    return self;
}

-(void) filterValueChanged:(SEFilterControl *)sender {
    [_delegate sliderValueChanged:sender.SelectedIndex];
}

@end