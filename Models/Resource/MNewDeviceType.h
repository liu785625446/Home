//
//  MNewDeviceType.h
//  Home
//
//  Created by 刘军林 on 15/8/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface MNewDeviceType : NSObject

@property (nonatomic, strong) NSString *rowid;
@property (nonatomic, strong) NSString *define_ID;
@property (nonatomic, strong) NSString *ico_img;
@property (nonatomic, strong) NSString *control_type;
@property (nonatomic, strong) NSString *name_ch;
@property (nonatomic, strong) NSString *name_en;
@property (nonatomic, strong) NSString *template_file;

-(id)objectForSet:(FMResultSet *)set;

@end
