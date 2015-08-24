//
//  SenceAirEditViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "SenceEntity.h"
#import "EntityRemote.h"

@protocol SenceAirEditDelegate <NSObject>

-(void) eidtAirSence:(EntityRemote *)entityRemote;

@end

@interface SenceAirEditViewController : UITableViewController

//@property (nonatomic, strong) SenceEntity *senceEntity;
@property (nonatomic, strong) EntityRemote *entityRemote;

@property (nonatomic, strong) IBOutlet UISwitch *switchBut;
//是否扫风
@property (nonatomic, strong) IBOutlet UISwitch *sweptBut;

@property (nonatomic, strong) IBOutlet UIButton *airTypeBut1;
@property (nonatomic, strong) IBOutlet UIButton *airTypeBut2;
@property (nonatomic, strong) IBOutlet UIButton *airTypeBut3;
@property (nonatomic, strong) IBOutlet UIButton *airTypeBut4;
@property (nonatomic, strong) IBOutlet UIButton *airTypeBut5;
@property (nonatomic, strong) UIButton *airTypeCurrentBut;

@property (nonatomic, strong) IBOutlet UIButton *airWindBut1;
@property (nonatomic, strong) IBOutlet UIButton *airWindBut2;
@property (nonatomic, strong) IBOutlet UIButton *airWindBut3;
@property (nonatomic, strong) IBOutlet UIButton *airWindBut4;
@property (nonatomic, strong) UIButton *airWindCurrentBut;

@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut16;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut17;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut18;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut19;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut20;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut21;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut22;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut23;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut24;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut25;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut26;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut27;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut28;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut29;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut30;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut31;
@property (nonatomic, strong) IBOutlet UIButton *airCelsiusBut32;
@property (nonatomic, strong) UIButton *airCelsiusCurrentBut;

@property (nonatomic, weak) id<SenceAirEditDelegate> delegate;

-(IBAction)airTypeAction:(id)sender;

-(IBAction)airWindAction:(id)sender;

-(IBAction)airCelsiusAction:(id)sender;

-(IBAction)saveSenceAirAction:(id)sender;

@end
