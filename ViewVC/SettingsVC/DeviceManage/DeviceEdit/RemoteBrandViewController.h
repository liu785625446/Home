//
//  RemoteBrandViewController.h
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceManageTableViewController.h"
#import "DeviceEditViewController.h"

@interface RemoteBrandViewController : UICollectionViewController <UIAlertViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) DeviceManageTableViewController *deviceManageDelegate;
@property (nonatomic, weak) DeviceEditViewController *deviceEditDelegate;

@property (nonatomic, strong) NSString *entity_id;
@property (assign) int remoteType;

@property (assign) int current_index;

@property (nonatomic, strong) NSArray *brand_list;
@property (nonatomic, strong) NSArray *pattern_list;

@end
