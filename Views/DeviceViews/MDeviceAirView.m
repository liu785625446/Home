//
//  MDeviceAirView.m
//  Home
//
//  Created by 刘军林 on 15/8/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceAirView.h"
#import "Interface.h"
#import "Tool.h"

@interface MDeviceAirView ()

@property (nonatomic, strong) IBOutlet UIImageView *windRating;
@property (nonatomic, strong) IBOutlet UIImageView *temperatureTen;
@property (nonatomic, strong) IBOutlet UIImageView *temperatureBits;
@property (nonatomic, strong) IBOutlet UIImageView *temperatureCel;
@property (nonatomic, strong) IBOutlet UIImageView *modelImg;

@property (nonatomic, strong) IBOutlet UIImageView *sweptImg;
@property (nonatomic, strong) IBOutlet UILabel *sweptName;

@property (nonatomic, strong) IBOutlet UILabel *isWindAuto;
@property (nonatomic, strong) IBOutlet UILabel *modeName;


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

@implementation MDeviceAirView

@synthesize windRating;
@synthesize temperatureTen;
@synthesize temperatureBits;
@synthesize temperatureCel;
@synthesize modelImg;

@synthesize switchStatus;
@synthesize modeStatus;
@synthesize windStatus;
@synthesize celsiusStatusTen;
@synthesize celsiusStatusBits;

@synthesize mailsBut;
@synthesize modelBut;
@synthesize windBut;
@synthesize temperatureAddBut;
@synthesize temperatureMinusBut;

- (void)awakeFromNib {
    // Initialization code
    
    self.mailsBut.tag = MAILSTAG;
    self.modelBut.tag = MODELTAG;
    self.windBut.tag = WINDTAG;
    self.temperatureAddBut.tag = TEMPERATUREADDTAG;
    self.temperatureMinusBut.tag = TEMPERATUREMINUSTAG;
    self.sweptBut.tag = SWEPTTAG;
    
    _user = [NSUserDefaults standardUserDefaults];
    
    if (![_user objectForKey:@"switch"]) {
        
        modeStatus = 1;
        windStatus = 3;
        celsiusStatusBits = 6;
        celsiusStatusTen = 2;
        _celsiusValue = 26;
        switchStatus = 0;
        _sweptStatus = 1;
        
    }else{
        
        modeStatus = [[_user objectForKey:@"mode"] intValue];
        windStatus = [[_user objectForKey:@"wind"] intValue];
        _celsiusValue = [[_user objectForKey:@"celsius"] intValue];
        switchStatus = [[_user objectForKey:@"switch"] intValue];
        _sweptStatus = [[_user objectForKey:@"swept"] intValue];
        
        celsiusStatusBits = _celsiusValue%10;
        celsiusStatusTen = _celsiusValue/10;
        
    }
    
    if (switchStatus == 0) {
        self.windRating.hidden = YES;
        self.temperatureTen.hidden = YES;
        self.temperatureBits.hidden = YES;
        self.temperatureCel.hidden = YES;
        self.modelImg.hidden = YES;
    }else {
        self.windRating.hidden = NO;
        self.temperatureTen.hidden = NO;
        self.temperatureBits.hidden = NO;
        self.temperatureCel.hidden = NO;
        self.modelImg.hidden = NO;
    }
    
    [self refreshMain];
    
    [self.mailsBut setBackgroundImage:[UIImage imageNamed:@"button_air_power_over.png"]
                             forState:UIControlStateHighlighted];
    [self.modelBut setBackgroundImage:[UIImage imageNamed:@"button_air_model_over.png"]
                             forState:UIControlStateHighlighted];
    [self.windBut setBackgroundImage:[UIImage imageNamed:@"button_air_model_wind_over.png"]
                            forState:UIControlStateHighlighted];
    [self.temperatureAddBut setBackgroundImage:[UIImage imageNamed:@"button_air_temperature_big_over.png"]
                                      forState:UIControlStateHighlighted];
    [self.temperatureMinusBut setBackgroundImage:[UIImage imageNamed:@"button_air_temperature_small_over.png"]
                                        forState:UIControlStateHighlighted];
    [self.sweptBut setBackgroundImage:[UIImage imageNamed:@"button_air_model_sweepwind_over.png"]
                             forState:UIControlStateHighlighted];
}

-(void) refreshMain
{
    NSString *windImgStr = @"";
    _isWindAuto.hidden = YES;
    if (windStatus == 0) {
        windImgStr = @"icon_wind_auto.png";
        _isWindAuto.hidden = NO;
    }else if (windStatus == 1) {
        windImgStr = @"icon_wind_small.png";
    }else if (windStatus == 2) {
        windImgStr = @"icon_wind_mid.png";
    }else if (windStatus == 3) {
        windImgStr = @"icon_wind_big.png";
    }
    
    NSString *modelImgStr = @"";
    if (modeStatus == 0) {
        modelImgStr = @"icon_m_auto.png";
        _modeName.text = @"自动";
    }else if (modeStatus == 1) {
        modelImgStr = @"icon_m_snow.png";
        _modeName.text = @"制冷";
    }else if (modeStatus == 2) {
        modelImgStr = @"icon_m_chushi.png";
        _modeName.text = @"抽湿";
    }else if (modeStatus == 3) {
        modelImgStr = @"icon_m_wind.png";
        _modeName.text = @"送风";
    }else if (modeStatus == 4) {
        modelImgStr = @"icon_m_sun.png";
        _modeName.text = @"制热";
    }
    
    if (_sweptStatus == 0) {
        _sweptImg.hidden = NO;
        _sweptName.hidden = NO;
    }else{
        _sweptImg.hidden = YES;
        _sweptName.hidden = YES;
    }
    
    self.temperatureTen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",celsiusStatusTen]];
    self.temperatureBits.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",celsiusStatusBits]];
    self.windRating.image = [UIImage imageNamed:windImgStr];
    self.modelImg.image = [UIImage imageNamed:modelImgStr];
    self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1.0];
}

-(IBAction)airRemoteAction:(id)sender
{
    NSTimeInterval tempTime = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"temp:%f",tempTime);
    
    if (_timeInterval) {
        
        NSLog(@"_time%f,temp:%f",_timeInterval,tempTime);
        
        if (_timeInterval + 0.3 >= tempTime) {
            NSLog(@"按键过快");
            return;
        }
        
    }
    _timeInterval = tempTime;
    
    UIButton *but = (UIButton*)sender;
    
    //    空调当前按下的键值
    int airKeyValue = -1;
    
    if (but.tag == MAILSTAG) {
        airKeyValue = 1;
        if (switchStatus == 0) {
            switchStatus = 1; //开关状态
            self.windRating.hidden = NO;
            self.temperatureCel.hidden = NO;
            self.temperatureTen.hidden = NO;
            self.temperatureBits.hidden = NO;
            self.modelImg.hidden = NO;
            self.modeName.hidden = NO;
            self.sweptImg.hidden = NO;
            self.sweptName.hidden = NO;
        }else {
            switchStatus = 0;
            self.windRating.hidden = YES;
            self.temperatureBits.hidden = YES;
            self.temperatureTen.hidden = YES;
            self.temperatureCel.hidden = YES;
            self.modelImg.hidden = YES;
            self.modeName.hidden = YES;
            self.sweptImg.hidden = YES;
            self.sweptName.hidden = YES;
        }
    }
    
    if (but.tag == MODELTAG) {
        
        airKeyValue = 4;
        modeStatus ++;
        if (modeStatus >= 5) {
            modeStatus = 0;
        }
        NSLog(@"mode:%d",modeStatus);
        NSString *modelImgStr = @"";
        if (modeStatus == 0) {
            modelImgStr = @"icon_m_auto.png";
            _modeName.text = @"自动";
        }else if (modeStatus == 1) {
            modelImgStr = @"icon_m_snow.png";
            _modeName.text = @"制冷";
        }else if (modeStatus == 2) {
            modelImgStr = @"icon_m_chushi.png";
            _modeName.text = @"抽湿";
        }else if (modeStatus == 3) {
            modelImgStr = @"icon_m_wind.png";
            _modeName.text = @"送风";
        }else if (modeStatus == 4) {
            modelImgStr = @"icon_m_sun.png";
            _modeName.text = @"制热";
        }
        
        NSLog(@"model:%@",modelImgStr);
        self.modelImg.image = [UIImage imageNamed:modelImgStr];
        
    }else if (but.tag == WINDTAG) {
        
        airKeyValue = 5;
        windStatus ++;
        if (windStatus == 4) {
            windStatus = 0;
        }
        
        NSString *windImgStr = @"";
        _isWindAuto.hidden = YES;
        if (windStatus == 0) {
            windImgStr = @"icon_wind_auto.png";
            _isWindAuto.hidden = NO;
        }else if (windStatus == 1) {
            windImgStr = @"icon_wind_small.png";
        }else if (windStatus == 2) {
            windImgStr = @"icon_wind_mid.png";
        }else if (windStatus == 3) {
            windImgStr = @"icon_wind_big.png";
        }
        
        self.windRating.image = [UIImage imageNamed:windImgStr];
    }else if (but.tag == TEMPERATUREADDTAG) {
        airKeyValue = 2;
        if (celsiusStatusTen != 3) {
            if (celsiusStatusBits == 9) {
                celsiusStatusTen += 1;
                celsiusStatusBits = 0;
            }else{
                celsiusStatusBits ++;
            }
        }
        self.temperatureTen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",celsiusStatusTen]];
        self.temperatureBits.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",celsiusStatusBits]];
    }else if (but.tag == TEMPERATUREMINUSTAG) {
        airKeyValue = 3;
        if (celsiusStatusBits !=6 || celsiusStatusTen !=1) {
            if (celsiusStatusBits == 0) {
                celsiusStatusTen --;
                celsiusStatusBits = 9;
            }else{
                celsiusStatusBits --;
            }
        }
        self.temperatureTen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",celsiusStatusTen]];
        self.temperatureBits.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",celsiusStatusBits]];
    }else if (but.tag == SWEPTTAG) {
        if (_sweptStatus == 0) {
            _sweptStatus = 1;
            
            _sweptName.hidden = YES;
            _sweptImg.hidden = YES;
        }else if (_sweptStatus == 1) {
            _sweptStatus = 0;
            _sweptName.hidden = NO;
            _sweptImg.hidden = NO;
        }
    }
    
    NSString *sendMsg = [NSString stringWithFormat:@"%@&%@&%@&0&%@&%d&%d&%d&%d&%d&%d&0&0&0&0&0",_entityId,_deviceType,_brand,_brandGroupIndex,airKeyValue,switchStatus,modeStatus,celsiusStatusTen * 10 + celsiusStatusBits,windStatus,_sweptStatus];
    
    NSLog(@"空调数据发送:%@",sendMsg);
    [Tool soundAction];
    [[Interface shareInterface:nil] writeFormatDataAction:@"39" didMsg:sendMsg didCallBack:^(NSString *code){
        NSLog(@"msg:%@",code);
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
