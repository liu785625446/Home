//
//  DeviceResource.m
//  Home
//
//  Created by 刘军林 on 14-7-25.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DeviceResource.h"

@implementation DeviceResource

@synthesize device_name;
@synthesize default_icon;
@synthesize open_icon;
@synthesize close_icon;
@synthesize icon_tag;

+(NSString *) getDefaultImage:(int)index
{
    return [DeviceResource objectForIndex:index].open_icon;
}

+(NSString *)getOpenImage:(int)index
{
    return [DeviceResource objectForIndex:index].open_icon;
}

+(NSString *) getCloseImage:(int)index
{
    return [DeviceResource objectForIndex:index].close_icon;
}

+(NSString *)getDeviceDefaultImg:(int)index
{
    NSString *deviceImgTag = @"";
    switch (index) {
        case 0:
            deviceImgTag = @"1";
            break;
            
        case 1:
            deviceImgTag = @"12";
            break;
            
        case 2:
            deviceImgTag = @"4";
            break;
            
        case 3:
            deviceImgTag = @"31";
            break;
        
        case 4:
            deviceImgTag = @"18";
            break;
        
        case 5:
            deviceImgTag = @"8";
            break;
            
        case 6:
            deviceImgTag = @"";
            break;
            
        case 7:
            deviceImgTag = @"29";
            break;
            
        case 8:
            deviceImgTag = @"12";
            break;

        case 9:
            deviceImgTag = @"12";
            break;
            
        default:
            break;
    }
    return deviceImgTag;
}

+(NSString *) getDeviceDefaultName:(int)index
{
    NSString *deviceName = @"";
    switch (index) {
        case 0:
            deviceName = @"插座";
            break;
            
        case 1:
            deviceName = @"三路面板";
            break;
            
        case 2:
            deviceName = @"窗帘";
            break;
            
        case 3:
            deviceName = @"红外遥控";
            break;
            
        case 4:
            deviceName = @"门磁";
            break;
            
        case 5:
            deviceName = @"红外探测";
            break;
            
        case 6:
            deviceName = @"";
            break;
            
        case 7:
            deviceName = @"烟感";
            break;
        
        case 8:
            deviceName = @"二路面板";
            break;
            
        case 9:
            deviceName = @"一路面板";
            break;
        default:
            break;
    }
    return deviceName;
}

+(DeviceResource *) objectForIndex:(int)index
{
    DeviceResource *resource = [[DeviceResource alloc] init];
    
    resource.icon_tag = index;
    switch (index) {
        case 0:
        {
            resource.device_name = @"MR.j";
            resource.open_icon = @"icon_mrjmr";
            resource.close_icon = @"icon_mrjmr_off";
        }
            break;
            
        case 1:
        {
            resource.device_name = @"插座";
            resource.open_icon = @"icon_chazuo1.png";
            resource.close_icon = @"icon_chazuo1_off.png";
        }
            break;
            
        case 2:
        {
            resource.device_name = @"插座";
            resource.open_icon = @"icon_chazuo2.png";
            resource.close_icon = @"icon_chazuo2_off.png";
        }
            break;
            
        case 3:
        {
            resource.device_name = @"插座";
            resource.open_icon = @"icon_chazuo3.png";
            resource.close_icon = @"icon_chazuo3_off.png";
        }
            break;
            
        case 4:
        {
            resource.device_name = @"窗帘";
            resource.open_icon = @"icon_chuanglianmianban.png";
            resource.close_icon = @"icon_chuanglianmianban_off.png";
        }
            break;
            
        case 5:
        {
            resource.device_name = @"窗帘";
            resource.open_icon = @"icon_chuanglianmianban2.png";
            resource.close_icon = @"icon_chuanglianmianban2_off.png";
        }
            break;
            
        case 6:
        {
            resource.device_name = @"窗帘";
            resource.open_icon = @"icon_chuanglianmianban3.png";
            resource.close_icon = @"icon_chuanglianmianban3_off.png";
        }
            break;
        
        case 7:
        {
            resource.device_name = @"窗帘";
            resource.open_icon = @"icon_chuanglianmianban4.png";
            resource.close_icon = @"icon_chuanglianmianban4_off.png";
        }
            break;
        
        case 8:
        {
            resource.device_name = @"红外";
            resource.open_icon = @"icon_hongwai.png";
            resource.close_icon = @"icon_hongwai_off.png";
        }
            break;
            
        case 9:
        {
            resource.device_name = @"红外";
            resource.open_icon = @"icon_hongwai2.png";
            resource.close_icon = @"icon_hongwai2_off.png";
        }
            break;
            
        case 10:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan1.png";
            resource.close_icon = @"icon_kaiguan1_off.png";
        }
            break;
            
        case 11:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan2.png";
            resource.close_icon = @"icon_kaiguan2_off.png";
        }
            break;
            
        case 12:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan3.png";
            resource.close_icon = @"icon_kaiguan3_off.png";
        }
            break;
            
        case 13:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan4.png";
            resource.close_icon = @"icon_kaiguan4_off.png";
        }
            break;
            
        case 14:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan5.png";
            resource.close_icon = @"icon_kaiguan5_off.png";
        }
            break;
            
        case 15:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan6.png";
            resource.close_icon = @"icon_kaiguan6_off.png";
        }
            break;
            
        case 16:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan7.png";
            resource.close_icon = @"icon_kaiguan7_off.png";
        }
            break;
            
        case 17:
        {
            resource.device_name = @"开关";
            resource.open_icon = @"icon_kaiguan8.png";
            resource.close_icon = @"icon_kaiguan8_off.png";
        }
            break;
            
        case 18:
        {
            resource.device_name = @"门磁";
            resource.open_icon = @"icon_mengci.png";
            resource.close_icon = @"icon_mengci_off.png";
        }
            break;
            
        case 19:
        {
            resource.device_name = @"门磁";
            resource.open_icon = @"icon_mengci2.png";
            resource.close_icon = @"icon_mengci2_off.png";
        }
            break;
            
        case 20:
        {
            resource.device_name = @"摄像头";
            resource.open_icon = @"icon_monitoring.png";
            resource.close_icon = @"icon_monitoring.png";
        }
            break;
            
        case 21:
        {
            resource.device_name = @"燃气";
            resource.open_icon = @"icon_ranqi.png";
            resource.close_icon = @"icon_ranqi_off.png";
        }
            break;
            
        case 22:
        {
            resource.device_name = @"燃气";
            resource.open_icon = @"icon_ranqi2.png";
            resource.close_icon = @"icon_ranqi2_off.png";
        }
            break;
            
        case 23:
        {
            resource.device_name = @"燃气";
            resource.open_icon = @"icon_ranqi3.png";
            resource.close_icon = @"icon_ranqi3_off.png";
        }
            break;
            
        case 24:
        {
            resource.device_name = @"空调";
            resource.open_icon = @"icon_sb_kt.png";
            resource.close_icon = @"icon_sb_kt.png";
        }
            break;
            
        case 25:
        {
            resource.device_name = @"空调";
            resource.open_icon = @"icon_sb_kt2.png";
            resource.close_icon = @"icon_sb_kt2.png";
        }
            break;
            
        case 26:
        {
            resource.device_name = @"电视";
            resource.open_icon = @"icon_sb_tv.png";
            resource.close_icon = @"icon_sb_tv.png";
        }
            break;
            
        case 27:
        {
            resource.device_name = @"电视";
            resource.open_icon = @"icon_sb_tv2.png";
            resource.close_icon = @"icon_sb_tv2.png";
        }
            break;
            
        case 28:
        {
            resource.device_name = @"电视";
            resource.open_icon = @"icon_sb_tv3.png";
            resource.close_icon = @"icon_sb_tv3.png";
        }
            break;
            
        case 29:
        {
            resource.device_name = @"烟感";
            resource.open_icon = @"icon_yanggang.png";
            resource.close_icon = @"icon_yanggang_off.png";
        }
            break;
            
        case 30:
        {
            resource.device_name = @"烟感";
            resource.open_icon = @"icon_yanggang2.png";
            resource.close_icon = @"icon_yanggang2_off.png";
        }
            break;
            
        case 31:
        {
            resource.device_name = @"红外遥控";
            resource.open_icon = @"icon_yaokong_hongwai.png";
            resource.close_icon = @"icon_yaokong_hongwai_off.png";
        }
            break;
            
        case 32:
        {
            resource.device_name = @"红外遥控";
            resource.open_icon = @"icon_yaokong_hongwai2.png";
            resource.close_icon = @"icon_yaokong_hongwai2_off.png";
        }
            break;
            
        case 33:
        {
            resource.device_name = @"baby";
            resource.open_icon = @"icon_qj_baby.png";
            resource.close_icon = @"icon_qj_baby.png";
        }
            break;
        case 34:
        {
            resource.device_name = @"baby";
            resource.open_icon = @"icon_qj_baby2.png";
            resource.close_icon = @"icon_qj_baby2.png";
        }
            break;
        case 35:
        {
            resource.device_name = @"白天";
            resource.open_icon = @"icon_qj_baitian.png";
            resource.close_icon = @"icon_qj_baitian.png";
        }
            break;
        case 36:
        {
            resource.device_name = @"白天";
            resource.open_icon = @"icon_qj_baitian2.png";
            resource.close_icon = @"icon_qj_baitian2.png";
        }
            break;
            
        case 37:
        {
            resource.device_name = @"布防";
            resource.open_icon = @"icon_qj_bufang.png";
            resource.close_icon = @"icon_qj_bufang.png";
        }
            break;
            
        case 38:
        {
            resource.device_name = @"重复";
            resource.open_icon = @"icon_qj_chongfu.png";
            resource.close_icon = @"icon_qj_chongfu.png";
        }
            break;
            
        case 39:
        {
            resource.device_name = @"定时";
            resource.open_icon = @"icon_qj_dingshi.png";
            resource.close_icon = @"icon_qj_dingshi.png";
        }
            break;
            
        case 40:
        {
            resource.device_name = @"在家";
            resource.open_icon = @"icon_qj_home.png";
            resource.close_icon = @"icon_qj_home.png";
        }
            break;
            
        case 41:
        {
            resource.device_name = @"就寝";
            resource.open_icon = @"icon_qj_jiuqin.png";
            resource.close_icon = @"icon_qj_jiuqin.png";
        }
            break;
            
        case 42:
        {
            resource.device_name = @"夜晚";
            resource.open_icon = @"icon_qj_night.png";
            resource.close_icon = @"icon_qj_night.png";
        }
            break;
            
        case 43:
        {
            resource.device_name = @"聚会";
            resource.open_icon = @"icon_qj_party.png";
            resource.close_icon = @"icon_qj_party.png";
        }
            break;
            
        case 44:
        {
            resource.device_name = @"聚会";
            resource.open_icon = @"icon_qj_party2.png";
            resource.close_icon = @"icon_qj_party2.png";
        }
            break;
            
        case 45:
        {
            resource.device_name = @"普通";
            resource.open_icon = @"icon_qj_putong.png";
            resource.close_icon = @"icon_qj_putong.png";
        }
            break;
            
        case 46:
        {
            resource.device_name = @"电影";
            resource.open_icon = @"icon_qj_tv.png";
            resource.close_icon = @"icon_qj_tv.png";
        }
            break;
            
        case 47:
        {
            resource.device_name = @"电影";
            resource.open_icon = @"icon_qj_tv2.png";
            resource.close_icon = @"icon_qj_tv2.png";
        }
            break;
            
        case 48:
        {
            resource.device_name = @"电影";
            resource.open_icon = @"icon_qj_tv3.png";
            resource.close_icon = @"icon_qj_tv3.png";
        }
            break;
            
        case 49:
        {
            resource.device_name = @"外出";
            resource.open_icon = @"icon_qj_waichu.png";
            resource.close_icon = @"icon_qj_waichu.png";
        }
            break;
            
        case 50:
        {
            resource.device_name = @"运动";
            resource.open_icon = @"icon_qj_yundong.png";
            resource.close_icon = @"icon_qj_yundong.png";
        }
            break;
            
        case 51:
        {
            resource.device_name = @"运动";
            resource.open_icon = @"icon_qj_yundong3.png";
            resource.close_icon = @"icon_qj_yundong3.png";
        }
            break;
            
        default:
            break;
    }
    
    return resource;
}

@end
