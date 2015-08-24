//
//  CustomButton1.m
//  FIS
//
//  Created by 刘军林 on 14-3-6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

@synthesize shape;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 0.3;
    
    CAShapeLayer *border = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddRoundedRect(ref, nil, self.bounds, 5, 5);
    border.path = ref;
    border.fillColor = [self.normalColor CGColor];
    
    [self.layer insertSublayer:border atIndex:0];
    
    [self addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpOutside];
}

-(void) downAction
{
    if (!shape) {
        shape = [[CAShapeLayer alloc] init];
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddRoundedRect(ref, nil, self.bounds, 5, 5);
        shape.path = ref;
        shape.fillColor = [self.selectColor CGColor];
    }
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.layer insertSublayer:shape atIndex:1];
}

-(void) upAction
{
    [shape removeFromSuperlayer];
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
