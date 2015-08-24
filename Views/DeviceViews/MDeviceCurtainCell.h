//
//  MDeviceCurtainCell.h
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewCell.h"

#import "BaseModel.h"

@class MDeviceCurtainCell;
@protocol MDeviceCurtainCellDelegate <NSObject>

-(void) deviceCurtain:(MDeviceCurtainCell *)deviceCurtain topButton:(UIButton *)but entityID:(NSString *)entityId;

@end

@interface MDeviceCurtainCell : MBaseTableViewCell

@property (nonatomic, weak) IBOutlet UIButton *c_stopBut;
@property (nonatomic, weak) IBOutlet UIButton *c_startBut;
@property (nonatomic, weak) IBOutlet UIButton *c_closeBut;

@property (nonatomic, weak) IBOutlet UIImageView *c_stopImg;
@property (nonatomic, weak) IBOutlet UIImageView *c_startImg;
@property (nonatomic, weak) IBOutlet UIImageView *c_closeImg;

@property (nonatomic, strong) BaseModel *baseModel;
@property (nonatomic, weak) id<MDeviceCurtainCellDelegate> delegate;

-(IBAction)curtainSwitchAction:(id)sender;

@end
