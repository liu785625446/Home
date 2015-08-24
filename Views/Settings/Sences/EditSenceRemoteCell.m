//
//  EditSenceRemoteCell.m
//  Home
//
//  Created by 刘军林 on 14-5-12.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EditSenceRemoteCell.h"
#import "DeviceResource.h"

@implementation EditSenceRemoteCell

@synthesize remoteImg;
@synthesize remoteName;
@synthesize remoteInfo;
@synthesize selectBut;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(NSString *) getModeStr:(int)index
{
    if (index == 0) {
        return @"自动";
    }else if (index == 1) {
        return @"制冷";
    }else if (index == 2) {
        return @"抽湿";
    }else if (index == 3) {
        return @"送风";
    }else{
        return @"制热";
    }
}

-(NSString *) getWindStr:(int)index
{
    if (index == 0) {
        return @"微风";
    }else if (index == 1) {
        return @"小风";
    }else if (index == 2) {
        return @"中风";
    }else{
        return @"大风";
    }
}

-(void) setEntityRemote:(EntityRemote *)entityRemote
{
    _entityRemote = entityRemote;
    [self.selectBut setImage:[UIImage imageNamed:@"cb_glossy_on.png"]
                    forState:UIControlStateSelected];
    if (_entityRemote.arcPower == 0) {
        self.remoteInfo.text = @"关闭";
    }else{
        self.remoteInfo.text = [NSString stringWithFormat:@"%@ %@ 温度:%d",[self getModeStr:_entityRemote.arcMode],[self getWindStr:_entityRemote.arcFan], _entityRemote.arcTemp];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
