//
//  CheckNetwork.m
//  Furniture
//
//  Created by 刘军林 on 13-12-18.
//  Copyright (c) 2013年 刘军林. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"

@implementation CheckNetwork

+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork=NO;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=NO;
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=YES;
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=YES;
            break;
    }
    return isExistenceNetwork;
}

+(BOOL) isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+(BOOL) isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
