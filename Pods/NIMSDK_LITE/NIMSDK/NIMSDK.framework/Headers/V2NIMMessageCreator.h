//
//  V2NIMMessageCreator.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2023 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class V2NIMMessage;

NS_ASSUME_NONNULL_BEGIN

@interface V2NIMMessageCreator : NSObject

/**
 *  创建文本消息
 *
 *  @param text 消息文本
 *
 *  @return 返回创建的消息
 */
+ (V2NIMMessage *)createTextMessage:(NSString *)text;

/**
 *  创建图片消息
 *
 *  @param imagePath 图片文件路径
 *
 *  @return 返回创建的消息
 */
+ (V2NIMMessage *)createImageMessage:(NSString *)imagePath;

@end

NS_ASSUME_NONNULL_END
