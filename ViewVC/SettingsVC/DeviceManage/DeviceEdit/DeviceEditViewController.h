//
//  DeviceEditViewController.h
//  Home
//
//  Created by 刘军林 on 14-7-29.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"
#import "EntityLine.h"
#import "SelectImgViewController.h"
#import "DeviceManageTableViewController.h"
#import "MBaseTableViewController.h"

@class EntityRemoteProcess;
@class EntityLineProcess;
@class EntityProcess;
@class EntityRemote;
@class SenceEntityProcess;
@class EntityLinkProcess;

@interface DeviceEditViewController : MBaseTableViewController<UITextFieldDelegate,SelectImgDelegate,UIAlertViewDelegate>
{
    int offsetHeight;
}

@property (nonatomic, weak) DeviceManageTableViewController *deviceManageDelegate;

@property (nonatomic, strong) EntityRemoteProcess *entityRemoteProcess;
@property (nonatomic, strong) EntityLineProcess *entityLineProcess;
@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) SenceEntityProcess *senceEntity;
@property (nonatomic, strong) EntityLinkProcess *entityLinkProcess;


@property (nonatomic, strong) Entity *entity;
@property (nonatomic, strong) UITextField *currentText;
@property (nonatomic, strong) UIButton *lastSaveBut;

//当设备为红外遥控
@property (nonatomic, strong) NSMutableArray *remote_list;
@property (nonatomic, strong) NSMutableArray *TV_list;
@property (nonatomic, strong) NSMutableArray *Air_list;
@property (nonatomic, strong) NSMutableArray *custom_list;
@property (nonatomic, strong) EntityRemote *currentRemote;


@property (nonatomic, strong) NSMutableArray *entityLine_list;
@property (nonatomic, strong) EntityLine *current_entityLine;

//联动设备是否联动
@property (assign) BOOL isLink;


-(IBAction)saveTitleAction:(id)sender;

//是否联动
-(IBAction)isLinkAction:(id)sender;

@end
