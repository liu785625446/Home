//
//  MDeviceTVCell.h
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityRemote.h"

#define TV_MAILS 2
#define TV_CHANNEL_ADD 14
#define TV_VOL_MUTE 1
#define TV_VOL_MINUS 15
#define TV_MENU 3
#define TV_VOL_ADD 12
#define TV_AV
#define TV_CHANNEL_MINUS 17
#define TV___ 35
#define TV_1 22
#define TV_2 23
#define TV_3 24
#define TV_4 25
#define TV_5 26
#define TV_6 27
#define TV_7 28
#define TV_8 29
#define TV_9 30
#define TV_0 32

@interface MDeviceTVCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *mailsBut;
@property (nonatomic, strong) IBOutlet UIButton *channel_addBut;
@property (nonatomic, strong) IBOutlet UIButton *vol_muteBut;
@property (nonatomic, strong) IBOutlet UIButton *vol_minusBut;
@property (nonatomic, strong) IBOutlet UIButton *menuBut;
@property (nonatomic, strong) IBOutlet UIButton *vol_addBut;
@property (nonatomic, strong) IBOutlet UIButton *channel_minusBut;
@property (nonatomic, strong) IBOutlet UIButton *tv__But;
@property (nonatomic, strong) IBOutlet UIButton *tv1_but;
@property (nonatomic, strong) IBOutlet UIButton *tv2_but;
@property (nonatomic, strong) IBOutlet UIButton *tv3_but;
@property (nonatomic, strong) IBOutlet UIButton *tv4_but;
@property (nonatomic, strong) IBOutlet UIButton *tv5_but;
@property (nonatomic, strong) IBOutlet UIButton *tv6_but;
@property (nonatomic, strong) IBOutlet UIButton *tv7_but;
@property (nonatomic, strong) IBOutlet UIButton *tv8_but;
@property (nonatomic, strong) IBOutlet UIButton *tv9_but;
@property (nonatomic, strong) IBOutlet UIButton *tv0_but;
@property (nonatomic, strong) IBOutlet UIButton *tv_Av_but;

@property (nonatomic, strong) EntityRemote *entityRemote;

-(IBAction)menuAction:(id)sender;

@end
