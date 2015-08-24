//
//  CustomTextField.m
//  FIS
//
//  Created by 刘军林 on 14-7-2.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.secureTextEntry) {
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

@end
