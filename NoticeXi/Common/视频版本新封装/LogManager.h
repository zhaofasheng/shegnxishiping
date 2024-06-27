//
//  LogManager.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/27.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogManager : NSObject


/**
* 获取单例实例
*
* @return 单例实例
*/
+ (instancetype) sharedInstance;

#pragma mark - Method

/**
* 写入日志
*
* @param module 模块名称
* @param logStr 日志信息,动态参数
*/
- (void)logInfo:(NSString*)module logStr:(NSString*)logStr;

/**
* 清空过期的日志
*/
- (void)clearExpiredLog;

/**
* 检测日志是否需要上传
*/
- (void)checkLogNeedUpload;

@end

NS_ASSUME_NONNULL_END
