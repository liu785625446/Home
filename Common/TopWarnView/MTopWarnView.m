//
//  MTopWarnView.m
//  Home
//
//  Created by 刘军林 on 15/4/24.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MTopWarnView.h"

@interface MTopWarnView ()

@property (nonatomic, strong) UILabel *m_warn_text;

@end

@implementation MTopWarnView

+(void) addTopWarnText:(NSString *)m_text view:(UIView *)m_view
{
    CGRect boundRect = [UIScreen mainScreen].bounds;
    MTopWarnView *m_topWarnView = [[MTopWarnView alloc] initWithFrame:CGRectMake(20, -40, boundRect.size.width - 20 * 2, 40)];
    [m_topWarnView setTopWarmText:m_text];
    [m_view addSubview:m_topWarnView];
}

+(void) addTopNetworkText:(NSString *)m_text
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *netWorkView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, window.frame.size.width, 40)];
    netWorkView.backgroundColor = [UIColor yellowColor];
    netWorkView.alpha = 0.9;
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 30)];
    text.textAlignment = NSTextAlignmentLeft;
    text.font = [UIFont systemFontOfSize:13];
    text.text = m_text;
    [netWorkView addSubview:text];
    
    [window addSubview:netWorkView];
}

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        self.alpha = 0.6;
        
        _m_warn_text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        _m_warn_text.font = [UIFont systemFontOfSize:13.0f];
        _m_warn_text.textColor = [UIColor whiteColor];
        _m_warn_text.textAlignment = NSTextAlignmentCenter;
        
        CGRect rect = _m_warn_text.frame;
        rect.origin.x = (self.frame.size.width - 200)/2;
        rect.origin.y = 5;
        _m_warn_text.frame = rect;
        self.layer.cornerRadius = 2.0f;
        [self addSubview:_m_warn_text];
    }
    
    return self;
}

-(void) setTopWarmText:(NSString *)m_text
{
    _m_warn_text.text = m_text;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = 0;
        self.frame = rect;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.frame;
                rect.origin.y = -self.frame.size.height;
                self.frame = rect;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
