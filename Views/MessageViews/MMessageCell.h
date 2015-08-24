//
//  MMessageCell.h
//  Home
//
//  Created by 刘军林 on 15/4/21.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"

@class AlarmInfos;

@interface MMessageCell : MBaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *msgTime;

@property (strong, nonatomic) IBOutlet UILabel *msgContent;

@property (nonatomic, strong) AlarmInfos *alarmInfo;
@end
