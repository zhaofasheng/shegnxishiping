//
//  CMKeyChain.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service ;
 
+ (void)save:(NSString *)service data:(id)data;
 
+ (id)load:(NSString *)service;
 
+ (void)delete:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
