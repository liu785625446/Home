//
//  RemotePatternViewController.h
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceManageTableViewController.h"
#import "DeviceEditViewController.h"
#import "MBaseViewController.h"

@class EntityProcess;
@class EntityRemoteProcess;

@interface RemotePatternViewController : MBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) DeviceManageTableViewController *deviceManageDelegate;
@property (nonatomic, weak) DeviceEditViewController *deviceEditDelegate;

@property (nonatomic, strong) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) NSString *patternAmount;

@property (assign) int remoteType;
@property (nonatomic, strong) NSString *remoteName;
//品牌索引
@property (assign) int remoteBrandIndex;
@property (assign) int remoteGroupIndex;
@property (nonatomic, strong) NSString *entity_id;

@property (assign) int current_index;

@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) EntityRemoteProcess *entityRemoteProcess;

-(IBAction)addRemoteAction:(id)sender;

@end
