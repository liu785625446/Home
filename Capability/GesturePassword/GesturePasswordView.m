//
//  GesturePasswordView.m
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"

@implementation GesturePasswordView{
    NSMutableArray *buttonArray;
    
    CGPoint lineStatePoint;
    CGPoint lineEndPoint;
}

@synthesize imgView;
@synthesize forgetButton;
@synthesize changeButton;

@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

-(id) initWithFrame:(CGRect)frame didStyle:(GestureStyle)style
{
    if (self = [super initWithFrame:frame]) {
        buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-160,
                                                                frame.size.height/2-80,
                                                                320,
                                                                320)];
        
        for (int i=0 ; i<9 ; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton *gesturePasswordButton = [[GesturePasswordButton alloc] initWithFrame:CGRectMake(col * distance + margin,
                                                                                                                   row * (distance -10),
                                                                                                                   size,
                                                                                                                   size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y = 0;
        [self addSubview:view];
        
        tentacleView = [[TentacleView alloc] initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2-150, frame.size.height/2+220, 120, 30)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetButton];
        
        changeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2+30, frame.size.height/2 + 195, 120, 30)];
        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [changeButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [changeButton setTitle:@"选择其它方式登入" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeButton];
    }
    

    
    if (style == Verify) {
        
        self.state = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - 140, frame.size.height/2-120 , 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:14.0f]];
        self.state.text = @"Mr.j智能安防";
        self.state.textColor = [UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1];
        [self addSubview:state];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 60 )/2,
                                                               self.state.frame.origin.y - 60 - 10,
                                                               60,
                                                               60)];
        [self.imgView setImage:[UIImage imageNamed:@"icon.png"]];
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2;
        self.imgView.clipsToBounds = YES;
        [self addSubview:imgView];

    }else {
        self.state = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-140, frame.size.height/2-120, 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:state];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-15, frame.size.width/2-80, 30, 30)];
        [imgView setImage:[UIImage imageNamed:@"seticon_handlogin.png"]];
        [self addSubview:imgView];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] = {
        134/255.0, 157/255.0, 147/255.0, 1.00,
        3/255.0, 3/255.0, 37/255.0,1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, self.frame.size.height), kCGGradientDrawsBeforeStartLocation);
}

-(void) gestureTouchBegin {
    [self.state setText:@"Mr.j智能安防"];
    self.state.textColor = [UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1];
}

-(void)forget
{
    [gesturePasswordDelegate forget];
}

-(void) change
{
    [gesturePasswordDelegate change];
}

@end
