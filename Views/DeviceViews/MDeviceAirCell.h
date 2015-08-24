//
//  MDeviceAirCell.h
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EntityRemote;

#define MAILSTAG 60
#define MODELTAG 63
#define WINDTAG 64
#define TEMPERATUREADDTAG 61
#define TEMPERATUREMINUSTAG 62
#define SWEPTTAG 65

@interface MDeviceAirCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *windRating;
@property (nonatomic, strong) IBOutlet UIImageView *temperatureTen;
@property (nonatomic, strong) IBOutlet UIImageView *temperatureBits;
@property (nonatomic, strong) IBOutlet UIImageView *temperatureCel;
@property (nonatomic, strong) IBOutlet UIImageView *modelImg;

@property (nonatomic, strong) IBOutlet UIImageView *sweptImg;
@property (nonatomic, strong) IBOutlet UILabel *sweptName;

@property (nonatomic, strong) IBOutlet UILabel *isWindAuto;
@property (nonatomic, strong) IBOutlet UILabel *modeName;

@property (nonatomic, strong) EntityRemote *entityRemote;

@property (assign) int switchStatus;
@property (assign) int modeStatus;
@property (assign) int windStatus;
@property (assign) int celsiusStatusTen;
@property (assign) int celsiusStatusBits;
@property (assign) int sweptStatus;

@property (assign) int celsiusValue;
@property (nonatomic, strong) NSUserDefaults *user;

@property (nonatomic, strong) IBOutlet UIButton *mailsBut;
@property (nonatomic, strong) IBOutlet UIButton *modelBut;
@property (nonatomic, strong) IBOutlet UIButton *windBut;
@property (nonatomic, strong) IBOutlet UIButton *temperatureAddBut;
@property (nonatomic, strong) IBOutlet UIButton *temperatureMinusBut;
@property (nonatomic, strong) IBOutlet UIButton *sweptBut;

@property (assign) NSTimeInterval timeInterval;

-(IBAction)airRemoteAction:(id)sender;

@end
