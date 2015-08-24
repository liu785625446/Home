//
//  MainClass.h
//  Home
//
//  Created by 刘军林 on 15/4/24.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interface.h"
#import "MessagePool.h"

@interface MainClass : NSObject <MessagePoolDelegate>

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) NSString *connectType;
@property (nonatomic, strong) NSString *connectIp;

@property (nonatomic, strong) NSMutableArray *messagePoolList;

/**
 *  初始化函数
 *
 *  @param delegate 委托
 *
 *  @return 对象
 */
-(id) initWithDelegate:(id)delegate;

-(void) requestConnectBox:(CallBackParamBlock)success Fail:(CallBackBlockErr)fail;

@end
