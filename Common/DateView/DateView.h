//
//  DateView.h
//  Home
//
//  Created by 刘军林 on 14/10/20.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DATEHEIGHT 254.0f

typedef enum : NSUInteger {
    DATE = 0,
    TIME,
    CUSTOM,
}pickerStyle;

@class DateView;
@protocol DateViewDelegate <NSObject>

-(void)canelAction:(DateView *)dateView;
-(void)doneAction:(DateView *)dateView;

@end

@interface DateView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) id<DateViewDelegate> delegate;

-(id) initWithFrame:(CGRect)frame DidStyle:(pickerStyle)style;

-(void) dateViewShowAction;
-(void) dateViewHideAction;
@end
