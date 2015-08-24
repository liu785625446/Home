//
//  Tool.m
//  Home
//
//  Created by 刘军林 on 14-1-22.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "Tool.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "Interface.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>
#import "URL.h"
#import "SVProgressHUD.h"

#define NSLog

static BOOL isHUD = NO;

static AVAudioPlayer *audioPlayer;
@implementation Tool

+(void) soundAction
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SHOCK]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

//wifi
+(id)fetchSSIDInfo
{
//    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
//    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
//    id info = nil;
//    for (NSString *ifnam in ifs) {
//        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        if (info && [info count]) {
//            break;
//        }
//    }
//    return info;
    return nil;
}

+(BOOL) isIos7Version{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(NSString *)getDate:(NSString *)dateTimer
{
    NSString *msgDate = @"";
    
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dateFor setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *date = [dateFor dateFromString:dateTimer];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit
    | NSMonthCalendarUnit
    | NSDayCalendarUnit
    | NSHourCalendarUnit
    | NSMinuteCalendarUnit
    | NSWeekCalendarUnit
    | NSWeekdayCalendarUnit
    | NSWeekdayOrdinalCalendarUnit;
    
    //    消息时间
    NSDateComponents *dateCom = [calendar components:unitFlags fromDate:date];
    //    本地时间
    NSDateComponents *localDate = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSLog(@"hour:%d,%d",dateCom.hour,localDate.hour);
    
    if (dateCom.year == localDate.year && dateCom.month == localDate.month && dateCom.day == localDate.day) {//同一天的
        
        if (dateCom.hour <= 6) {
            
            msgDate = [NSString stringWithFormat:@"凌晨 %d:%d",dateCom.hour,dateCom.minute];
            
        }else if (dateCom.hour <= 11) {
            
            msgDate = [NSString stringWithFormat:@"上午 %d:%d",dateCom.hour,dateCom.minute];
            
        }else if (dateCom.hour <= 13) {
            
            msgDate = [NSString stringWithFormat:@"中午 %d:%d",dateCom.hour,dateCom.minute];
            
        }else if (dateCom.hour <= 19) {
            
            msgDate = [NSString stringWithFormat:@"下午 %d:%d",dateCom.hour,dateCom.minute];
            
        }else if (dateCom.hour <= 23) {
            
            msgDate = [NSString stringWithFormat:@"晚上 %d:%d",dateCom.hour,dateCom.minute];
            
        }else {
            
            msgDate = [NSString stringWithFormat:@"凌晨 %d:%d",dateCom.hour,dateCom.minute];
            
        }
        
        msgDate = [NSString stringWithFormat:@"今天 %@",msgDate];
    }else if(dateCom.year == localDate.year && dateCom.month == localDate.month && dateCom.day+1 == localDate.day) { //昨天
        
        msgDate = [NSString stringWithFormat:@"昨天 %d:%d",dateCom.hour,dateCom.minute];
        
    }else if (dateCom.year == localDate.year && dateCom.month == localDate.month && dateCom.day+2 == localDate.day) {//前天
        
        msgDate = [NSString stringWithFormat:@"%@ %d:%d",[Tool getWeekStr:dateCom.weekday-1] ,dateCom.hour,dateCom.minute];
        
    }else {
        msgDate = [NSString stringWithFormat:@"%d-%d-%d %d:%d",dateCom.year,dateCom.month,dateCom.day,dateCom.hour,dateCom.minute];
    }
    
    return msgDate;
}

+(NSString *)getWeekStr:(int)week
{
    NSString *weekStr;
    switch (week) {
        case 1:
            weekStr = @"周一";
            break;
            
        case 2:
            weekStr = @"周二";
            break;
            
        case 3:
            weekStr = @"周三";
            break;
            
        case 4:
            weekStr = @"周四";
            break;
            
        case 5:
            weekStr = @"周五";
            break;
            
        case 6:
            weekStr = @"周六";
            break;
            
        case 7:
            weekStr = @"周日";
            break;
            
        default:
            break;
    }
    
    return weekStr;
}

+(BOOL) checkFormatStr:(NSString *)str
{
    BOOL isCheck = NO;
    NSRange range = [str rangeOfString:@"@"];
    if (range.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range1 = [str rangeOfString:@"&"];
    if (range1.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range2 = [str rangeOfString:@","];
    if (range2.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range3 = [str rangeOfString:@"$"];
    if (range3.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range4 = [str rangeOfString:@"%"];
    if (range4.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range5 = [str rangeOfString:@"@"];
    if (range5.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range6 = [str rangeOfString:@"^"];
    if (range6.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range7 = [str rangeOfString:@"*"];
    if (range7.location != NSNotFound) {
        isCheck = YES;
    }
    
    NSRange range8 = [str rangeOfString:@","];
    if (range8.location != NSNotFound) {
        isCheck = YES;
    }
    
    return isCheck;
}

+(CGFloat) getVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(void) showMyHUD:(NSString *)msg
{
    isHUD = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(20);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isHUD) {
                [Tool showFailHUD:@"连接失败!"];
            }
        });
    });
    [SVProgressHUD showWithStatus:msg maskType:SVProgressHUDMaskTypeBlack];
}

+(void) showSuccessHUD:(NSString *)msg
{
    isHUD = NO;
    [SVProgressHUD dismissWithSuccess:msg afterDelay:1.0];
}

+(void) showFailHUD:(NSString *)msg
{
    isHUD = NO;
    [SVProgressHUD dismissWithError:msg afterDelay:1.0];
}

+(void) hideMyHUD
{
    isHUD = NO;
    [SVProgressHUD dismiss];
}

+(void)showMyAlert:(NSString *)msg didDelegate:(id)delegate didTag:(int) tag
{
    if (tag) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:delegate
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
   
        alert.tag = tag;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:delegate
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

+(void)showMyAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+(NSString *) getDateForTimeIntervale:(NSTimeInterval)time
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"yyyy-MM-dd"];
    return [dateFor stringFromDate:d];
}

+(NSString *) getTimeForTimeIntervale:(NSTimeInterval)time
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"HH:mm"];
    return [dateFor stringFromDate:d];
}

+(BOOL) canOpenURL:(NSString *)url
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

+(void) startAnimationImgAction:(UIImageView *)img
{
    img.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1.0)];
    animation.duration = 0.5;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    
    [img.layer addAnimation:animation forKey:@"animation"];
}

+(void) stopAnimationImgAction:(UIImageView *)img
{
    [img.layer removeAllAnimations];
    img.hidden = YES;
}

+(void) buttonAnimationImgAction:(UIButton *)but didView:(UIView *)view
{
    UIColor *stroke = [UIColor grayColor];
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(but.bounds), -CGRectGetMidY(but.bounds), but.bounds.size.width, but.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:but.bounds.size.width/2];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [view convertPoint:but.center fromView:nil];
    
    NSLog(@"x:%f,y:%f",shapePosition.x,shapePosition.y);
    shapePosition.y = view.bounds.size.height/2;
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 1;
    
    [view.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
}

+(void) getUpdate:(UIViewController *)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *nowVersion = [infoDic objectForKey:@"CFBundleVersion"];
       
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:APPID forKey:@"key"];
        [dic setObject:@"phone" forKey:@"type"];
        [dic setObject:@"ios" forKey:@"platform"];
        
        [Interface POST:APP_URL url:@"App/app_version" parameters:dic success:^(NSURLSessionDataTask *task, id result){
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSString *newversion = [result objectForKey:@"version"];
                if (![newversion isEqualToString:nowVersion]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *info = [result objectForKey:@"info"];
                        NSString *name = [result objectForKey:@"name"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name
                                                                        message:info
                                                                       delegate:delegate
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"更新", nil];
                        alert.tag = ALERTUPDATE;
                        [alert show];
                    });
                }
            }
        }failure:^(NSURLSessionDataTask *task, NSError *error){
            
        }];
    });
}

+(void) customAddAutoLayoutSub:(UIView *)subView didSupView:(UIView *)supView
{
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:supView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    [supView addConstraint:constraintLeft];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:supView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    [supView addConstraint:constraintRight];
    
    NSLayoutConstraint *constraintTap = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:supView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    [supView addConstraint:constraintTap];
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:supView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [supView addConstraint:constraintBottom];
}

@end
