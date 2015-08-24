//
//  AddDeviceViewController.h
//  Home
//
//  Created by 刘军林 on 14-7-17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;


@interface AddDeviceViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>
{
    NSArray *imgList;
    NSArray *typeList;
}

@property (nonatomic, strong) SettingsViewController *settingsDelegate;
@property (assign) int deviceType;

@end
