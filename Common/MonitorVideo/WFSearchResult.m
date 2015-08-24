//
//  WFSearchResult.m
//  Home
//
//  Created by 刘军林 on 15/6/17.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "WFSearchResult.h"

@implementation WFSearchResult

@synthesize strDID;
@synthesize strSSID;
@synthesize strMac;
@synthesize security;
@synthesize db0;
@synthesize db1;
@synthesize mode;
@synthesize channel;

-(id)init
{
    if (self = [super init]) {
        strDID = @"";
        strSSID = @"";
        strMac = @"";
        security = 0;
        db0 = 0;
        db1 = 0;
        mode = 0;
        channel = 0;
    }
    return self;
}

@end
