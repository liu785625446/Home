//
//  MNewBrand.h
//  Home
//
//  Created by 刘军林 on 15/8/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface MNewBrand : NSObject

@property (nonatomic, strong) NSString *rowid;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *control_type;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *brand_ch;
@property (nonatomic, strong) NSString *brand_en;

-(id) objectForSet:(FMResultSet *)set;

@end
