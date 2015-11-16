//
//  VPNDemand.h
//  iVPN-iOS
//
//  Created by Steven on 15/11/16.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface VPNDemand : NSObject

+ (void)storeString:(NSString *)string key:(NSString *)key;

+ (nullable NSData *)getDataWithKey:(NSString *)key;

@end
NS_ASSUME_NONNULL_END