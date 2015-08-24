//
//  DeviceLinkTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"
#import "EntityLink.h"
#import "DeviceLinkCell.h"
#import "MBaseTableViewController.h"

@class EntityProcess;
@class EntityLinkProcess;

@interface DeviceLinkTableViewController : MBaseTableViewController<DeviceLinkCellDelegate>

@property (nonatomic, strong) NSMutableArray *entity_list;
@property (nonatomic, strong) NSMutableArray *entityLink_list;
@property (nonatomic, strong) Entity *linkEntity;
@property (nonatomic, strong) EntityProcess *entityProcess;

@property (nonatomic, strong) EntityLinkProcess *entityLinkProcess;
@end
