//
//  MSenceCell.h
//  Home
//
//  Created by 刘军林 on 15/4/21.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"

@class Sence;
@interface MSenceCell : MBaseTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *senceImg;
@property (nonatomic, strong) IBOutlet UILabel *senceName;
@property (nonatomic, strong) IBOutlet UILabel *senceStartMode;
@property (nonatomic, strong) IBOutlet UILabel *senceLastStartTime;

@property (nonatomic, weak) IBOutlet UIImageView *upImg;

@property (nonatomic, assign) BOOL *isStart;

@property (nonatomic, strong) Sence *sence;

@end

@interface MSenceMusicCell : MBaseTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *senceMusic;

@end
