//
//  MDeviceTVCell.m
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceTVCell.h"
#import "Tool.h"
#import "Interface.h"

@implementation MDeviceTVCell

@synthesize mailsBut;
@synthesize channel_addBut;
@synthesize vol_minusBut;
@synthesize vol_muteBut;
@synthesize menuBut;
@synthesize vol_addBut;
@synthesize channel_minusBut;
@synthesize tv__But;
@synthesize tv1_but;
@synthesize tv2_but;
@synthesize tv3_but;
@synthesize tv4_but;
@synthesize tv5_but;
@synthesize tv6_but;
@synthesize tv7_but;
@synthesize tv8_but;
@synthesize tv9_but;
@synthesize tv0_but;
@synthesize tv_Av_but;

- (void)awakeFromNib {
    // Initialization code
    
    self.mailsBut.tag = TV_MAILS;
    self.channel_addBut.tag = TV_CHANNEL_ADD;
    self.vol_minusBut.tag = TV_VOL_MINUS;
    self.vol_muteBut.tag = TV_VOL_MUTE;
    self.menuBut.tag = TV_MENU;
    self.vol_addBut.tag = TV_VOL_ADD;
    self.channel_minusBut.tag = TV_CHANNEL_MINUS;
    self.tv__But.tag = TV___;
    self.tv1_but.tag = TV_1;
    self.tv2_but.tag = TV_2;
    self.tv3_but.tag = TV_3;
    self.tv4_but.tag = TV_4;
    self.tv5_but.tag = TV_5;
    self.tv6_but.tag = TV_6;
    self.tv7_but.tag = TV_7;
    self.tv8_but.tag = TV_8;
    self.tv9_but.tag = TV_9;
    self.tv0_but.tag = TV_0;
    
    [self.mailsBut setImage:[UIImage imageNamed:@"button_air_power_over.png"]
                   forState:UIControlStateHighlighted];
    [self.channel_addBut setBackgroundImage:[UIImage imageNamed:@"button_tv_ch_add_over.png"]
                                   forState:UIControlStateHighlighted];
    [self.vol_muteBut setBackgroundImage:[UIImage imageNamed:@"button_tv_mute_over.png"]
                                forState:UIControlStateHighlighted];
    [self.vol_minusBut setBackgroundImage:[UIImage imageNamed:@"button_tv_voice_small_over"]
                                 forState:UIControlStateHighlighted];
    [self.menuBut setBackgroundImage:[UIImage imageNamed:@"button_menu_over.png"]
                            forState:UIControlStateHighlighted];
    [self.vol_addBut setBackgroundImage:[UIImage imageNamed:@"button_tv_voice_big_over.png"]
                               forState:UIControlStateHighlighted];
    [self.channel_minusBut setBackgroundImage:[UIImage imageNamed:@"button_tv_ch_reduction_over.png"]
                                     forState:UIControlStateHighlighted];
    [self.tv__But setBackgroundImage:[UIImage imageNamed:@"button_tv_num_over.png"]
                            forState:UIControlStateHighlighted];
    [self.tv_Av_but setBackgroundImage:[UIImage imageNamed:@"button_tv_avtv_over.png"]
                              forState:UIControlStateHighlighted];
    
    [self.tv0_but setImage:[UIImage imageNamed:@"button_tv_n0_over.png"] forState:UIControlStateHighlighted];
    [self.tv1_but setImage:[UIImage imageNamed:@"button_tv_n1_over.png"] forState:UIControlStateHighlighted];
    [self.tv2_but setImage:[UIImage imageNamed:@"button_tv_n2_over.png"] forState:UIControlStateHighlighted];
    [self.tv3_but setImage:[UIImage imageNamed:@"button_tv_n3_over.png"] forState:UIControlStateHighlighted];
    [self.tv4_but setImage:[UIImage imageNamed:@"button_tv_n4_over.png"] forState:UIControlStateHighlighted];
    [self.tv5_but setImage:[UIImage imageNamed:@"button_tv_n5_over.png"] forState:UIControlStateHighlighted];
    [self.tv6_but setImage:[UIImage imageNamed:@"button_tv_n6_over.png"] forState:UIControlStateHighlighted];
    [self.tv7_but setImage:[UIImage imageNamed:@"button_tv_n7_over.png"] forState:UIControlStateHighlighted];
    [self.tv8_but setImage:[UIImage imageNamed:@"button_tv_n8_over.png"] forState:UIControlStateHighlighted];
    [self.tv9_but setImage:[UIImage imageNamed:@"button_tv_n9_over.png"] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1.0];
    self.separatorInset = UIEdgeInsetsMake(0, self.frame.size.width, 0, 0);
}

-(IBAction)menuAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    [but setHighlighted:YES];
    
    NSString *sendMsg = [NSString stringWithFormat:@"%@&%d&%d&%d&%d&0&0&0&0&0",_entityRemote.entityId,_entityRemote.brandType,_entityRemote.remoteBrandIndex,_entityRemote.remoteGroupIndex,but.tag];
    
    NSLog(@"sendMsg:%@",sendMsg);
    
    [Tool soundAction];
    [[Interface shareInterface:nil] writeFormatDataAction:@"9"
                                                    didMsg:sendMsg
                                               didCallBack:^(NSString *code){
                                               }
     ];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
