//
//  AddDeviceCollCell.h
//  Home
//
//  Created by 刘军林 on 14-7-17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceCollCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *deviceImg;
@property (nonatomic, strong) IBOutlet UILabel *deviceType;

@property (nonatomic, assign) int index;

@end
