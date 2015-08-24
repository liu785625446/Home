//
//  MNewDeviceType.m
//  Home
//
//  Created by 刘军林 on 15/8/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MNewDeviceType.h"
#import "FMDatabase.h"

@implementation MNewDeviceType

@synthesize rowid;
@synthesize define_ID;
@synthesize ico_img;
@synthesize control_type;
@synthesize name_ch;
@synthesize name_en;
@synthesize template_file;

-(id) objectForSet:(FMResultSet *)set
{
    self.rowid = [NSString stringWithFormat:@"%@",[set stringForColumn:@"rowid"]];
    self.define_ID = [NSString stringWithFormat:@"%@",[set stringForColumn:@"define_ID"]];
    self.ico_img = [NSString stringWithFormat:@"%@",[set stringForColumn:@"ico_img"]];
    self.control_type = [NSString stringWithFormat:@"%@",[set stringForColumn:@"ID"]];
    self.name_ch = [NSString stringWithFormat:@"%@",[set stringForColumn:@"name_ch"]];
    self.name_en = [NSString stringWithFormat:@"%@",[set stringForColumn:@"name_en"]];
    self.template_file = [NSString stringWithFormat:@"%@",[set stringForColumn:@"template_file"]];
    return self;
}

@end
