//
//  EditSenceRemoteCell.h
//  Home
//
//  Created by 刘军林 on 14-5-12.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityRemote.h"

@interface EditSenceRemoteCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *remoteImg;
@property (nonatomic, strong) IBOutlet UILabel *remoteName;
@property (nonatomic, strong) IBOutlet UILabel *remoteInfo;
@property (nonatomic, strong) IBOutlet UIButton *selectBut;

@property (nonatomic, strong) EntityRemote *entityRemote;

@end
