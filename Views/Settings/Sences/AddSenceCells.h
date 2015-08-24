//
//  AddSenceCells.h
//  Home
//
//  Created by 刘军林 on 14-5-9.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEFilterControl.h"

@interface SenceNameCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *senceName;

@end

@interface SenceSelectCell : UITableViewCell

@end

@interface SenceImgCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *senceImg;

@end


@interface SenceSwitchCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *senceLabel;
@property (nonatomic, strong) IBOutlet UISwitch *senceSwitch;

@end


@interface SenceLabelCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *senceKey;
@property (nonatomic, strong) IBOutlet UILabel *senceValue;

@end

@class SenceSliderCell;

@protocol SenceSliderCellDelegate <NSObject>

-(void) sliderValueChanged:(int) index;

@end

@interface SenceSliderCell : UITableViewCell

@property (nonatomic, strong) id<SenceSliderCellDelegate> delegate;
@property (nonatomic, strong) SEFilterControl *filter;

@end
