//
//  MainClass.m
//  Home
//
//  Created by 刘军林 on 15/4/24.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MainClass.h"
#import "BaseModel.h"
#import "URL.h"
#import "Entity.h"

#define LOCALIP @"192.168.7.250"
#define CONNECTTYPE @"200"

@interface MainClass ()

@property (nonatomic, strong) Interface *interface;

@end

@implementation MainClass

-(id) initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _interface = [Interface shareInterface:_delegate];
        _messagePoolList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void) requestConnectBox:(CallBackParamBlock)success Fail:(CallBackBlockErr)fail
{
    _connectIp = @"";
    _connectType = @"";
    
    [_interface bindUDPService:^(NSString *code) {
//        判断是否为当前盒子
        if ([BOX_ID_VALUE isEqualToString:code]) {
//            判断是否为第一次进来,_connectIp 是否调用了转发
            if ([_connectIp isEqualToString:@""]) {
                _connectIp = LOCALIP;
                [_interface connectService:LOCALIP didConnectType:CONNECTTYPE didSuccess:^(NSString *code) {
                    success(code);
                } Fail:^(NSError *result, NSString *errInfo) {
                    fail(result, errInfo);
                }];
            }
        }
    }];
    [self queryTransferIpConnect:success fail:fail];
}

-(void) queryTransferIpConnect:(CallBackParamBlock)success fail:(CallBackBlockErr)fail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dic setObject:[user objectForKey:U_PAD_ID] forKey:U_PAD_ID];
    [dic setObject:[user objectForKey:U_TOKEN] forKey:U_TOKEN];
    [dic setObject:[user objectForKey:U_BOX_ID] forKey:U_BOX_ID];
    
    [Interface POST:DDNS_360FIS
                url:FINDIP
         parameters:dic
            success:^(NSURLSessionDataTask *task, id result) {
                
                if ([result isKindOfClass:[NSDictionary class]]) {
                    if ([[result objectForKey:@"return"] isEqualToString:@"0"]) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([_connectIp isEqualToString:@""]) {
                                if ([[result objectForKey:@"status"] isEqualToString:@"404"]) {
                                    _connectType = @"404";
                                    _connectIp = [result objectForKey:@"ip"];
                                }else if ([[result objectForKey:@"status"] isEqualToString:@"200"]){
                                    _connectType = @"200";
                                    _connectIp = [result objectForKey:@"ip"];
                                }
                                [_interface connectService:_connectIp didConnectType:_connectType didSuccess:^(NSString *code) {
                                    success(code);
                                } Fail:^(NSError *result, NSString *errInfo) {
                                    fail(result, errInfo);
                                }];
                            }
                        });
                    }else{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([_connectIp isEqualToString:@""]) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                message:@"验证过期，请重新绑定"
                                                                               delegate:_delegate
                                                                      cancelButtonTitle:nil
                                                                      otherButtonTitles:@"确定", nil];
                                alert.tag = ALERTREBINDING;
                                [alert show];
                            }
                        });
                    }
                }
    }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_connectIp isEqualToString:@""]) {
                        fail(error,nil);
                    }
                });
    }];
}

@end
