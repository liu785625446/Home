//
//  LoadConnectView.m
//  Home
//
//  Created by 刘军林 on 14-7-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MInitConnectView.h"

@implementation MInitConnectView

@synthesize activity;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect rect = [UIScreen mainScreen].bounds;
        
        _img = [[UIImageView alloc] initWithFrame:rect];
        if (rect.size.height == 480) {
            [_img setImage:[UIImage imageNamed:@"Default.png"]];
        }else if (rect.size.height == 568) {
            [_img setImage:[UIImage imageNamed:@"Default-568h.png"]];
        }else if (rect.size.height == 667) {
            [_img setImage:[UIImage imageNamed:@"Default-375w-667.png"]];
        }else if (rect.size.height == 736) {
            [_img setImage:[UIImage imageNamed:@"Default-414w-736h.png"]];
        }
        
        self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((rect.size.width - 40) / 2, (rect.size.height - 100), 40, 40)];
        self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.activity.color = [UIColor grayColor];
        [self.activity startAnimating];
        [self addSubview:_img];
        [self addSubview:self.activity];
        
//        self.connectStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, self.activity.frame.origin.y + 40, rect.size.width, 20)];
//        self.connectStatus.textAlignment = NSTextAlignmentCenter;
//        self.connectStatus.textColor = [UIColor grayColor];
//        self.connectStatus.text = @"连接中...";
//        self.connectStatus.font = [UIFont systemFontOfSize:14.0f];
//        [self addSubview:self.connectStatus];
    }
    return self;
}

-(void) setConnectText:(NSString *)c_text didTextColor:(UIColor *)t_color
{
    if (t_color) {
        [self.connectStatus setTextColor:t_color];
    }
    
    if (c_text) {
        self.connectStatus.text = c_text;
    }
}

-(void) removeInitConnectView
{
    [self removeFromSuperview];
    [_delegate mInitContentComplete:self];
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
