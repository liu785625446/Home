//
//  MRoomsViewController.h
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"

@class RoomsProcess;

typedef enum : NSUInteger {
    ROOMADD = 1000,
    ROOMUPDATE,
    
} ROOMTYPE;

@interface MRoomsViewController : MBaseTableViewController<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *roomsList;

@property (nonatomic, assign) NSInteger  updateRoomRow;

@property (nonatomic, strong) RoomsProcess *roomsProcess;

@end
