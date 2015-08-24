//
//  AddSenceViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sence.h"
#import "MBaseTableViewController.h"
#import "AddSenceCells.h"
#import "SelectImgViewController.h"
#import "SelectWeekTableViewController.h"

@class SenceEntityProcess;

@interface AddSenceViewController : MBaseTableViewController<SenceSliderCellDelegate,SelectImgDelegate,SelectWeekDelegate,UIActionSheetDelegate>{
    int offsetHeight;
}
@property (nonatomic, strong) UITextField *senceName;
@property (nonatomic, strong) UISwitch *timingStart;
@property (nonatomic, strong) UISwitch *timingWeek;

@property (nonatomic, strong) Sence *sence;
@property (nonatomic, strong) NSMutableArray *device_list;

@property (nonatomic, strong) SenceEntityProcess *senceEntityProcess;

//判断是否保存情景
@property (assign) BOOL isSave;
@property (assign) int add_1_or_update_2;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *dateTool;
@property (nonatomic, strong) UIView *dateView;


-(IBAction)senceSwitchAction:(id)sender;
-(IBAction)saveSenceAction:(id)sender;
@end
