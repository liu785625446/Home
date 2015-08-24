//
//  getImageList.h
//  Home
//
//  Created by 刘军林 on 14-8-26.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"

enum {
    _DEFAULTICON = 0,
    _SWITCHICON1,
    _SWITCHICON2,
    _SWITCHICON3,
    _JACKICON,
    _CURTAINICON,
    _TVICON,
    _AIRICON,
    _SENCEICON,
    _MAG,
    _PIR, //红外探测
    _SMKEN  //烟感
    
};

@interface ImageList : BaseModel

+(NSMutableArray *)getImageList:(int)type;

@end
