//
//  MMonitorCell.h
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"

@class Camerainfos;

@interface MMonitorCell : MBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *selectImg;
@property (strong, nonatomic) IBOutlet UIImageView *monitorImg;
@property (strong, nonatomic) IBOutlet UILabel *monitorName;

@property (strong, nonatomic) IBOutlet UIButton *backPlayBut;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *selectWidth;


@property (strong, nonatomic) Camerainfos *camerainfos;

@end
