//
//  RemoteTypeCell.h
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteTypeCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *remoteImg;
@property (nonatomic, strong) IBOutlet UILabel *remoteName;
@property (nonatomic, assign) int index;
@end

@interface RemoteBrandCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *brand;
@property (nonatomic, assign) int index;

@end

@interface RemotePatternCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *pattern;
@property (nonatomic, assign) int index;

@end
