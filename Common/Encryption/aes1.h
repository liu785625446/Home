//
//  aes.h
//  AES
//
//  Created by luc on 14-3-31.
//  Copyright (c) 2014年 luc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码

@end