//
//  MDeviceRemoteCell.h
//  Home
//
//  Created by 刘军林 on 15/6/4.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionButton.h"

@interface MDeviceRemoteCell : UITableViewCell <UISearchBarDelegate, CustomButtonDelegate>
{
    NSInteger butStatus;
}

@property (nonatomic, strong) NSString *oldStr;

@property (nonatomic, strong) IBOutlet UIButton *volReduceBut;
@property (nonatomic, strong) IBOutlet UIButton *volAddBut;

@property (nonatomic, strong) IBOutlet DirectionButton *customBut;
@property (nonatomic, strong) IBOutlet UIButton *defineBut;

@property (nonatomic, strong) IBOutlet UIButton *homeBut;
@property (nonatomic, strong) IBOutlet UIButton *backBut;
@property (nonatomic, strong) IBOutlet UIButton *keyBoardBut;
@property (nonatomic, strong) IBOutlet UIButton *moreBut;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) UIToolbar *toolbar;

@end
