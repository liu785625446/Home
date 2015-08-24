//
//  MDeviceRoomCell.m
//  Home
//
//  Created by 刘军林 on 15/4/23.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceRoomHeadCell.h"

@implementation MDeviceRoomHeadCell

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDeviceRoomCellAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        self.userInteractionEnabled = YES;
        
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) tapDeviceRoomCellAction:(id) sender
{
    if ([_delegate respondsToSelector:@selector(MDeviceRoomHead:didSelectSection:)]) {
        [_delegate MDeviceRoomHead:self didSelectSection:self.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
