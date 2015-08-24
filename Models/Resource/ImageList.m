//
//  getImageList.m
//  Home
//
//  Created by 刘军林 on 14-8-26.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "ImageList.h"
#import "DeviceResource.h"

@implementation ImageList

+(NSMutableArray *)getImageList:(int)type
{
    NSMutableArray *image_list = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *array;
    switch (type) {
        case _DEFAULTICON:
        {
            array = @[@"0"];
        }
            break;
        
        case _SWITCHICON2:
        {
            array = @[@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
        }
            break;
            
        case _SWITCHICON3:
        {
            array = @[@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
        }
            break;
        
        case _JACKICON:
        {
            array = @[@"1",@"2",@"3",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
        }
            break;
            
        case _CURTAINICON:
        {
            array = @[@"4", @"5", @"6", @"7"];
        }
            break;
            
        case _TVICON:{
            array = @[@"26", @"27", @"28"];
        }
            
            break;
            
        case _AIRICON:
        {
            array = @[@"24", @"25"];
        }
            break;
            
        case _SENCEICON:
        {
            array =@[@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51" ];
        }
            
            break;
            
        case _MAG:
        {
            array = @[@"18", @"19"];
        }
            break;
            
        case _PIR:
        {
            array = @[@"8",@"9"];
        }
            break;
            
        case _SMKEN:
        {
            array = @[@"29", @"30"];
        }
            break;
            
        default:
            break;
    }
    
    for (NSString *imageTag in array) {
        [image_list addObject:[DeviceResource objectForIndex:[imageTag intValue]]];
    }
    
    return image_list;
}

@end
