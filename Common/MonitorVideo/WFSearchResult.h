//
//  WFSearchResult.h
//  Home
//
//  Created by 刘军林 on 15/6/17.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFSearchResult : NSObject

@property (nonatomic, strong) NSString *strDID;
@property (nonatomic, strong) NSString *strSSID;
@property (nonatomic, strong) NSString *strMac;
@property (nonatomic, assign) NSInteger security;
@property (nonatomic, assign) NSInteger db0;
@property (nonatomic, assign) NSInteger db1;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) NSInteger channel;

@end
