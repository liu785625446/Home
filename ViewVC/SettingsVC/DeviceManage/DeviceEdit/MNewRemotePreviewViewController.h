//
//  MNewRemotePreviewViewController.h
//  Home
//
//  Created by 刘军林 on 15/8/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNewDeviceType;
@class MNewBrand;

@interface MNewRemotePreviewViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *backView;

@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) MNewDeviceType *deviceType;
@property (nonatomic, strong) MNewBrand *brand;
@property (nonatomic, strong) NSString *brandGroupIndex;

@end
