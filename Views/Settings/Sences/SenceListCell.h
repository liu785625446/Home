//
//  SenceListCell.h
//  Home
//
//  Created by 刘军林 on 14-5-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sence.h"

@interface SenceListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *senceImg;
@property (nonatomic, strong) IBOutlet UILabel *senceName;
@property (nonatomic, strong) IBOutlet UILabel *senceInfo;
@property (nonatomic, strong) IBOutlet UILabel *senceTimeInfo;

@property (nonatomic, strong) Sence *sence;

@end
