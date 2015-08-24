//
//  MDeviceStartCell.m
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceStartCell.h"
#import "Interface.h"
#import "Entity.h"
#import "EntityLine.h"
#import "Tool.h"

@implementation MDeviceStartCell

-(void) setBaseModel:(BaseModel *)baseModel
{
    NSLog(@"cell刷新");
    [self setSeparatorInset:UIEdgeInsetsMake(0, self.frame.size.width, 0, 0)];
    _baseModel = baseModel;
    
    if ([_baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)_baseModel;
        
        if ([entity.entityType intValue] != CURTAIN_SWITCH) {
            if (entity.isAnimation) {
                [self.deviceStart setEnabled:NO];
                [Tool startAnimationImgAction:_startLoading];
            }else{
                [self.deviceStart setEnabled:YES];
                [Tool stopAnimationImgAction:_startLoading];
            }
        }
        
        if (entity.state == 0) {
            [self.deviceStart setImage:[UIImage imageNamed:@"buttonx__open.png"] forState:UIControlStateNormal];
        }else{
            [self.deviceStart setImage:[UIImage imageNamed:@"button_x_close.png"] forState:UIControlStateNormal];
        }
        
    }else if ([_baseModel isKindOfClass:[EntityLine class]]) {
        
        EntityLine *entityLine = (EntityLine *)_baseModel;
        if (entityLine.isAnimation) {
            [self.deviceStart setEnabled:NO];
            [Tool startAnimationImgAction:_startLoading];
        }else{
            [self.deviceStart setEnabled:YES];
            [Tool stopAnimationImgAction:_startLoading];
        }
        
        if (entityLine.state == 0) {
            [self.deviceStart setImage:[UIImage imageNamed:@"buttonx__open.png"] forState:UIControlStateNormal];
        }else {
            [self.deviceStart setImage:[UIImage imageNamed:@"button_x_close.png"] forState:UIControlStateNormal];
        }
    }
    self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1.0];

}

-(IBAction)deviceStartAction:(id)sender
{
    NSString *msg;
    UIButton *but = (UIButton *)sender;
 
    [self.deviceStart setEnabled:NO];
    [Tool startAnimationImgAction:_startLoading];
    
    NSString *entityID = @"";
    if ([_baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)_baseModel;
        
        entity.isAnimation = YES;
        entityID = entity.entityID;
        msg = [NSString stringWithFormat:@"%@&%@",entity.entityID,@"0"];
        
    }else if ([_baseModel isKindOfClass:[EntityLine class]]) {
        EntityLine *entityLine = (EntityLine *)_baseModel;
        entityLine.isAnimation = YES;
        entityID = entityLine.entityID;
        msg = [NSString stringWithFormat:@"%@&%@",entityLine.entityID, entityLine.entityLineNum];
    }
    
    NSLog(@"开关控制:%@",msg);
    [[Interface shareInterface:nil] writeFormatDataAction:@"71" didMsg:msg didCallBack:^(NSString *code) {
        }];
    if ([_delegate respondsToSelector:@selector(deviceStart:tapButton:entityID:)]) {
        [_delegate deviceStart:self tapButton:but entityID:entityID];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
