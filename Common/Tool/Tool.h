//
//  Tool.h
//  Home
//
//  Created by 刘军林 on 14-1-22.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define SHOCK @"shock"
#define ALERT_EXIT_TAG 9999

@interface Tool : NSObject

/**
 *  播放系统声音
 */
+(void) soundAction;

/**
 *  获取当前链接的wifi信息
 *
 *  @return wifi信息对象
 */
+(id)fetchSSIDInfo;

/**
 *  判断是否为ios7以上系统
 *
 *  @return
 */
+(BOOL) isIos7Version;

+ (BOOL) validateMobile:(NSString *)mobile;

+(NSString *)getDate:(NSString *)dateTimer;

+(CGFloat) getVersion;

+(BOOL) checkFormatStr:(NSString *)str;

/**
 *  提示对话框
 *
 *  @param msg 对话框信息
 */
+(void)showMyAlert:(NSString *)msg;

/**
 *  对话框
 *
 *  @param msg      对话框信息
 *  @param delegate 对话框delegate
 *  @param tag      对话框tag
 */
+(void)showMyAlert:(NSString *)msg didDelegate:(id)delegate didTag:(int) tag;


+(void) showMyHUD:(NSString *)msg;
+(void) showFailHUD:(NSString *)msg;
+(void) showSuccessHUD:(NSString *)msg;
+(void) hideMyHUD;

/**
 *  判断网页有效性
 *
 *  @param url 网页地址
 *
 *  @return YES：可打开   NO：不可打开
 */
+(BOOL) canOpenURL:(NSString *)url;

/**
 *  秒数转日期
 *
 *  @param time 1970到当前的秒数
 *
 *  @return 返回日期 yyyy-MM-dd
 */
+(NSString *) getDateForTimeIntervale:(NSTimeInterval)time;

/**
 *  秒数转时间
 *
 *  @param time 1970到当前的秒数
 *
 *  @return 返回时间 HH:mm
 */
+(NSString *) getTimeForTimeIntervale:(NSTimeInterval)time;

/**
 *  md5加密
 *
 *  @param str 加密数据
 *
 *  @return 加密后的数据
 */
+(NSString *)md5:(NSString *)str;

/**
 *  启动旋转动画
 *
 *  @param img 旋转对象
 */
+(void) startAnimationImgAction:(UIImageView *)img;

/**
 *  停止旋转动画
 *
 *  @param img 旋转对象
 */
+(void) stopAnimationImgAction:(UIImageView *)img;

/**
 *  点击按钮动画
 *
 *  @param but  动画按钮
 *  @param view 动画视图
 */
+(void) buttonAnimationImgAction:(UIButton *)but didView:(UIView *)view;

+(void) getUpdate:(UIViewController *) delegate;

+(void) customAddAutoLayoutSub:(UIView *)subView didSupView:(UIView *)supView;

@end
