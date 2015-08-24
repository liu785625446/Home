//
//  AddDeviceCollCell.m
//  Home
//
//  Created by 刘军林 on 14-7-17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddDeviceCollCell.h"

@implementation AddDeviceCollCell

@synthesize deviceImg;
@synthesize deviceType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ref = UIGraphicsGetCurrentContext();
    if (_index < 3) {
        CGContextSetLineWidth(ref, 0.2);
        CGContextSetStrokeColorWithColor(ref, [[UIColor grayColor] CGColor]);
        CGContextMoveToPoint(ref, 0, 0);
        CGContextAddLineToPoint(ref, rect.size.width, 0);
        CGContextAddLineToPoint(ref, rect.size.width, rect.size.height);
        CGContextAddLineToPoint(ref, 0, rect.size.height);
    }else{
        CGContextSetLineWidth(ref, 0.2);
        CGContextSetStrokeColorWithColor(ref, [[UIColor grayColor] CGColor]);
        CGContextMoveToPoint(ref, rect.size.width, 0);
        CGContextAddLineToPoint(ref, rect.size.width, rect.size.height);
        CGContextAddLineToPoint(ref, 0, rect.size.height);
    }
    CGContextStrokePath(ref);
    
    UIView *selectBackground = [[UIView alloc] initWithFrame:self.frame];
    selectBackground.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectedBackgroundView = selectBackground;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
