//
//  MDeviceStartCell.h
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"
#import "BaseModel.h"

@class MDeviceStartCell;
@protocol MDeviceStartCellDelegate <NSObject>

-(void) deviceStart:(MDeviceStartCell *)deviceStart tapButton:(UIButton *)tapButton entityID:(NSString *)entityID;

@end

@interface MDeviceStartCell : MBaseTableViewCell

@property (nonatomic, weak) IBOutlet UIButton *deviceStart;
@property (nonatomic, weak) IBOutlet UIImageView *startLoading;

@property (nonatomic, weak) id<MDeviceStartCellDelegate> delegate;

@property (nonatomic, strong) BaseModel *baseModel;

@end
