//
//  SelectImgViewController.h
//  Home
//
//  Created by 刘军林 on 14-5-15.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectImgDelegate <NSObject>

-(void) selectImg:(NSString *)image;

@end

@interface SelectImgViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (assign) int type;
@property (nonatomic, strong) NSMutableArray *img_list;
@property (nonatomic, weak) id<SelectImgDelegate> delegate;

@end
