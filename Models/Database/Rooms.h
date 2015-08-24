//
//  Rooms.h
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "BaseModel.h"

@interface Rooms : BaseModel

@property (nonatomic, strong) NSString *boxId;
@property (nonatomic, strong) NSString *roomId;                 //房间ID
@property (nonatomic, strong) NSString *roomName;               //房间名字

//extern
@property (nonatomic, assign) NSInteger currentStartRow;
@property (nonatomic, strong) NSMutableArray *roomDeviceList;
@property (nonatomic, assign) BOOL isOpen;

@end
