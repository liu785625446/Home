//
//  MDeviceCurtainCell.m
//  Home
//
//  Created by 刘军林 on 15/5/22.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MDeviceCurtainCell.h"
#import "Tool.h"
#import "Entity.h"
#import "Interface.h"

@implementation MDeviceCurtainCell

-(void) setBaseModel:(BaseModel *)baseModel
{
    _baseModel = baseModel;
    Entity *entity = (Entity *)_baseModel;
    
    if (entity.isLeftAnimation) {
        [_c_startBut setEnabled:NO];
        [Tool startAnimationImgAction:_c_startImg];
    }else{
        [_c_startBut setEnabled:YES];
        [Tool stopAnimationImgAction:_c_startImg];
    }
    
    if (entity.isMiddleAnimation) {
        [_c_stopBut setEnabled:NO];
        [Tool startAnimationImgAction:_c_stopImg];
    }else{
        [_c_stopBut setEnabled:YES];
        [Tool stopAnimationImgAction:_c_stopImg];
    }
    
    if (entity.isRightAnimation) {
        [_c_closeBut setEnabled:NO];
        [Tool startAnimationImgAction:_c_closeImg];
    }else{
        [_c_closeBut setEnabled:YES];
        [Tool stopAnimationImgAction:_c_closeImg];
    }
    self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2" alpha:1.0];
}

-(IBAction)curtainSwitchAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    
    NSString *msg;
    Entity *entity = (Entity *)_baseModel;
    [but setEnabled:NO];
    if (sender == _c_startBut) {
        msg = [NSString stringWithFormat:@"%@&%d&%d&%d",entity.entityID, entity.link, 0,0];
        [Tool startAnimationImgAction:_c_startImg];
        entity.isLeftAnimation = YES;
    }else if (sender == _c_stopBut) {
        msg = [NSString stringWithFormat:@"%@&%d&%d&%d",entity.entityID, entity.link, 2,0];
        [Tool startAnimationImgAction:_c_stopImg];
        entity.isMiddleAnimation = YES;
    }else if (sender == _c_closeBut) {
        msg = [NSString stringWithFormat:@"%@&%d&%d&%d",entity.entityID, entity.link, 1,0];
        [Tool startAnimationImgAction:_c_closeImg];
        entity.isRightAnimation = YES;
    }
    
    [[Interface shareInterface:nil] writeFormatDataAction:@"6" didMsg:msg didCallBack:^(NSString *code) {
        
    }];
    if ([_delegate respondsToSelector:@selector(deviceCurtain:topButton:entityID:)]) {
        [_delegate deviceCurtain:self topButton:but entityID:entity.entityID];
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
