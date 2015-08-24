//
//  DateView.m
//  Home
//
//  Created by 刘军林 on 14/10/20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DateView.h"

#define TOOLBAR_HEIGHT 38

@interface DateView ()

@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation DateView

-(id) initWithFrame:(CGRect)frame DidStyle:(pickerStyle)style
{
    if (self = [super initWithFrame:frame]) {
        
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TOOLBAR_HEIGHT)];
        _toolBar.barStyle = UIBarStyleDefault;
        
        UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(toolbarCanelAction)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:Nil
                                                                               action:nil];
        UIBarButtonItem *doneBar = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(toolbarDoneAction)];
        
        [cancelBar setTintColor:[UIColor grayColor]];
        [doneBar setTintColor:[UIColor grayColor]];
        [_toolBar setItems:[NSArray arrayWithObjects:cancelBar, space, doneBar, nil]];
        
        CGRect boundRect = [UIScreen mainScreen].bounds;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 38.0, boundRect.size.width, 0.5)];
        [line setBackgroundColor:[UIColor grayColor]];
        line.alpha = 0.5;
        
        if (style == DATE || style == TIME) {
            
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                         TOOLBAR_HEIGHT,
                                                                         frame.size.width,
                                                                         frame.size.height - TOOLBAR_HEIGHT)];
            _datePicker.backgroundColor = [UIColor whiteColor];
            
            if (style == DATE) {
                _datePicker.datePickerMode = UIDatePickerModeDate;
            }else {
                _datePicker.datePickerMode = UIDatePickerModeTime;
            }
            [self addSubview:_datePicker];
            
        }else if (style == CUSTOM){
            
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                         TOOLBAR_HEIGHT,
                                                                         frame.size.width,
                                                                         frame.size.height-TOOLBAR_HEIGHT)];
            _pickerView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_pickerView];
        }
        [self addSubview:_toolBar];
        [self addSubview:line];
    }
    return self;
}

-(void) dateViewShowAction
{
    CGRect rect = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [self setFrame:CGRectMake(0,
                                                           rect.size.height - self.frame.size.height,
                                                           self.frame.size.width,
                                                           self.frame.size.height)
                             ];
                        }completion:nil];
}

-(void) dateViewHideAction
{
    CGRect rect = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setFrame:CGRectMake(0, rect.size.height, self.frame.size.width, self.frame.size.height)];
    }completion:nil];
}

-(void) toolbarCanelAction
{
    [_delegate canelAction:self];
}

-(void) toolbarDoneAction
{
    [_delegate doneAction:self];
}

@end
