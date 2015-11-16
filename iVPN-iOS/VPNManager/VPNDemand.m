//
//  VPNDemand.m
//  iVPN-iOS
//
//  Created by Steven on 15/11/16.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "VPNDemand.h"
#import <NetworkExtension/NetworkExtension.h>


@implementation VPNDemand

+ (void)storeString:(NSString *)string key:(NSString *)key
{
    NSData * stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    dic[(__bridge id)kSecAttrGeneric] = keyData;
    dic[(__bridge id)kSecAttrAccount] = keyData;
    dic[(__bridge id)kSecAttrService] = [[NSBundle mainBundle] bundleIdentifier];
    dic[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    dic[(__bridge id)kSecValueData] = stringData;
    SecItemDelete((__bridge CFDictionaryRef)dic);
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dic, NULL);
    if (status != errSecSuccess) {
        NSLog(@"Unable add item with key =%@ error:%d", key, (int)status);
    }
}

+ (nullable NSData *)getDataWithKey:(NSString *)key
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSData * keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    dic[(__bridge id)kSecAttrGeneric] = keyData;
    dic[(__bridge id)kSecAttrAccount] = keyData;
    dic[(__bridge id)kSecAttrService] = [[NSBundle mainBundle] bundleIdentifier];
    dic[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    dic[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    dic[(__bridge id)kSecReturnPersistentRef] = (__bridge id)kCFBooleanTrue;
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dic, &result);
    if (status != errSecSuccess) {
        NSLog(@"Unable to fetch item for key = %@ with error:%d", key, (int)status);
    }
    
    return (__bridge NSData *)result;
}


@end