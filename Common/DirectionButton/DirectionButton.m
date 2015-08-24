//
//  CustomButton.m
//  Home
//
//  Created by 刘军林 on 14-1-9.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DirectionButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Tool.h"

@interface DirectionButton ()
{
    int status;
}
@property (nonatomic) Direction currentDirection;                   //当前遥控方向
@property (nonatomic, strong) UIImageView *imageView;               //遥控背景图
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentPressTag;
@end

@implementation DirectionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_fx00.png"]];
    [_imageView setFrame:CGRectMake(
                                   0,
                                   0,
                                   [self bounds].size.width,
                                   [self bounds].size.height
                                   )];
    [self addSubview:_imageView];
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(longPressGestureAction:)];
    longGes.delegate = self;
    longGes.allowableMovement = 1;
    longGes.minimumPressDuration = 0.001;
    longGes.numberOfTouchesRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longGes];
    _currentDirection = DirectionNone;
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(longPressAction:) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    self.delegate = nil;
    [_timer invalidate];
    _timer = nil;
}

-(void) longPressAction:(id)sender
{
//    NSLog(@"长按111");
//    if (_isLongPress) {
//        [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",20]];
//        sleep(0.1);
//        [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",20]];
//    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"触摸开始");
//    CGPoint curPoint = [[touches anyObject] locationInView:self];
//    Direction direction = [self directionForPoint:curPoint];
//    _currentDirection = direction;
}

//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"触摸移动");
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"触摸结束");
//}

//长按手势
-(void)longPressGestureAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"长按");
    CGPoint curPoint = [gesture locationInView:self];
    Direction direction = [self directionForPoint:curPoint];
    _currentDirection = direction;
    
    [self updateImage:nil];
    
    if (gesture.state == 1) { //按下
        _isLongPress = YES;
        [Tool soundAction];
        switch (direction) {
            case DirectionTop:
                status = 19;
                break;
            case DirectionBottom:
                status = 20;
                break;
                
            case DirectionUpLeft:
                status = 21;
                break;
                
            case DirectionRight:
                status = 22;
                break;
            default:
                break;
        }
        _currentPressTag = status;
        [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",status]];
        return;
    }
    
    if (gesture.state == 2) { //移动
        NSLog(@"移动");
        switch (direction) {
            case DirectionTop:
                
                if (_currentPressTag != 19) {
                    [Tool soundAction];
                }
                _currentPressTag = 19;
                if (status != 19 && status != -1 && status != 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",19]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",19]];
                }else if (status == 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",19]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",19]];
                }else if (status == 19) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",19]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",19]];
                }
                break;
            case DirectionBottom:
               
                if (_currentPressTag != 20) {
                    [Tool soundAction];
                }
                 _currentPressTag = 20;

                if (status != 20 && status != -1 &&status != 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",20]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",20]];
                }else if (status == 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",20]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",20]];
                }else if (status == 20) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",20]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",20]];
                }
                break;
                
            case DirectionUpLeft:
                
                if (_currentPressTag != 21) {
                    [Tool soundAction];
                }
                _currentPressTag = 21;
                if (status != 21 && status != -1 &&status != 0) {

                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",21]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",21]];
                }else if (status == 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",21]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",21]];
                }else if (status == 21) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",21]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",21]];
                }

                break;
                
            case DirectionRight:
                if (_currentPressTag != 22) {
                    [Tool soundAction];
                }
                _currentPressTag = 22;
                
                if (status != 22 && status != -1 &&status != 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",22]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",22]];
                }else if (status == 0) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",22]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",22]];
                }else if (status == 22) {
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",22]];
                    status = -1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        status = 0;
                    });
                    sleep(0.3);
                    [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"0&%d",22]];
                }
                break;
            default:
                break;
        }
        return;

    }
    
    if (gesture.state == 3) { //抬起
        _isLongPress = NO;
        _currentDirection = DirectionNone;
        [self performSelector:@selector(updateImage:)
                   withObject:nil
                   afterDelay:0.2];
        [_delegate directionDown:self didMsg:[NSString stringWithFormat:@"1&%d",_currentPressTag]];
    }
}

- (Direction)directionForPoint:(CGPoint)point
{
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    if (x>y && x+y<247) {
        return DirectionTop;
    }else if (x>y && x+y > 247){
        return DirectionRight;
    }else if (y>x && x+y > 247){
        return DirectionBottom;
    }else if (y>x && x+y < 247){
        return DirectionUpLeft;
    }else{
        return DirectionNone;
    }
    
    return DirectionNone;
}

- (UIImage *)imageForDirection:(Direction)direction
{
    UIImage *image = nil;
    switch (direction) {
        case DirectionTop:
            image = [UIImage imageNamed:@"button_fxup.png"];
            break;
            
        case DirectionBottom:
            image =  [UIImage imageNamed:@"button_fxbottom.png"];
            break;
            
        case DirectionUpLeft:
            image =  [UIImage imageNamed:@"button_fxleft.png"];
            break;
            
        case DirectionRight:
            image =  [UIImage imageNamed:@"button_fxright.png"];
            break;
            
        case DirectionNone:
            image =  [UIImage imageNamed:@"button_fx00.png"];
            break;
            
        default:
            break;
    }
    return image;
}

- (void)updateImage:(id) sender
{
    _imageView.image = [self imageForDirection:_currentDirection];
}

@end
