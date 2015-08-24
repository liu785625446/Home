//
//  MonitorVideoDelegate.h
//  Home
//
//  Created by 刘军林 on 15/3/17.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#ifndef Home_MonitorVideoDelegate_h
#define Home_MonitorVideoDelegate_h

@class MonitorVideo;
@protocol MonitorVideoDelegate <NSObject>

-(void) dynamicSetFrame:(int) width didHeight:(int) height;

-(void) closeMonitorAction;
-(void) doubleTapAction;

-(void) connectStatusChange:(NSString *)statusStr didSSID:(NSString *)ssid;
-(void) connectWifiList;
-(void) connectCurrentWifi;

-(void) searchSDCardRecordFileList:(NSMutableArray *)recordList;

-(void) openBackPlayAction;

@end

#endif
