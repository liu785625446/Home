//
//  MNewBrand.m
//  Home
//
//  Created by 刘军林 on 15/8/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MNewBrand.h"
#import "FMDatabase.h"

@implementation MNewBrand

@synthesize rowid;
@synthesize control_type;
@synthesize ID;
@synthesize brand_ch;
@synthesize brand_en;

-(id) objectForSet:(FMResultSet *)set
{
    self.rowid = [NSString stringWithFormat:@"%@",[set stringForColumn:@"rowid"]];
    self.control_type = [NSString stringWithFormat:@"%@",[set stringForColumn:@"control_type"]];
    self.ID = [NSString stringWithFormat:@"%@",[set stringForColumn:@"ID"]];
    self.brand_ch = [NSString stringWithFormat:@"%@",[set stringForColumn:@"brand_ch"]];
    self.brand_en = [NSString stringWithFormat:@"%@",[set stringForColumn:@"brand_en"]];
    return self;
}

@end
