//
//  V2NIMMessageServiceProtocol.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2023 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "V2NIMBase.h"
#import "V2NIMMessageEnum.h"

@class V2NIMMessage;
@class V2NIMMessagePushOption;
@class V2NIMMessageAntiSpamOption;
@class V2NIMMessageConfig;
@class V2NIMMessageUpdatedInfo;

@class V2NIMSendMessageParam;
@class V2NIMSendMessageResult;

@protocol V2NIMMessageSendListener;
@protocol V2NIMMessageReceiveListener;
@protocol V2NIMMessageUpdateListener;
@protocol V2NIMMessageAttachmentListener;

NS_ASSUME_NONNULL_BEGIN

/// 发送消息成功回调
typedef void (^V2NIMSendMessageSuccessCallback)(V2NIMMessage *message,
                                                V2NIMSendMessageResult *__nullable result);

/// 消息服务协议
@protocol V2NIMMessageService <NSObject>

/**
 *  发送消息到会话
 *
 *  @param message 要发送的消息
 *  @param conversationId 要发送到的会话id
 *  @param param 发送参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *  @param progress 进度回调
 */
- (void)sendMessage:(V2NIMMessage *)message
     conversationId:(NSString *)conversationId
              param:(nullable V2NIMSendMessageParam *)param
            success:(nullable V2NIMSendMessageSuccessCallback)success
            failure:(nullable V2NIMFailureCallback)failure
           progress:(nullable V2NIMProgressCallback)progress;

/**
 *  重发消息
 *
 *  @param message 要发送的消息
 *  @param success 成功回调
 *  @param failure 失败回调
 *  @param progress 进度回调
 *
 *  @discussion 使用sendMessage发送失败后，使用此方法重发消息，此方法会使用sendMessage时指定的param作为发送参数
 */
- (void)resendMessage:(V2NIMMessage *)message
              success:(nullable V2NIMSendMessageSuccessCallback)success
              failure:(nullable V2NIMFailureCallback)failure
             progress:(nullable V2NIMProgressCallback)progress;

/**
 *  撤回消息
 *
 *  @param message 要撤回的消息
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)revokeMessage:(V2NIMMessage *)message
              success:(nullable V2NIMSuccessCallback)success
              failure:(nullable V2NIMFailureCallback)failure;

/**
 *  添加消息发送监听器
 *
 *  @param listener 监听器
 */
- (void)addMessageSendListener:(id<V2NIMMessageSendListener>)listener;

/**
 *  移除消息发送监听器
 *
 *  @param listener 监听器
 */
- (void)removeMessageSendListener:(id<V2NIMMessageSendListener>)listener;

/**
 *  添加消息接收监听器
 *
 *  @param listener 监听器
 */
- (void)addMessageReceiveListener:(id<V2NIMMessageReceiveListener>)listener;

/**
 *  移除消息接收监听器
 *
 *  @param listener 监听器
 */
- (void)removeMessageReceiveListener:(id<V2NIMMessageReceiveListener>)listener;

/**
 *  添加消息更新监听器
 *
 *  @param listener 监听器
 */
- (void)addMessageUpdateListener:(id<V2NIMMessageUpdateListener>)listener;

/**
 *  移除消息更新监听器
 *
 *  @param listener 监听器
 */
- (void)removeMessageUpdateListener:(id<V2NIMMessageUpdateListener>)listener;

/**
 *  添加消息附件监听器
 *
 *  @param listener 监听器
 */
- (void)addMessageAttachmentListener:(id<V2NIMMessageAttachmentListener>)listener;

/**
 *  移除消息附件监听器
 *
 *  @param listener 监听器
 */
- (void)removeMessageAttachmentListener:(id<V2NIMMessageAttachmentListener>)listener;

@end

/// 消息发送监听协议
@protocol V2NIMMessageSendListener <NSObject>
@optional

/**
 *  消息发送回调
 *
 *  @param message 发送中的消息
 */
- (void)onSendMessage:(V2NIMMessage *)message;

@end

/// 消息接收监听协议
@protocol V2NIMMessageReceiveListener <NSObject>
@optional

/**
 *  消息接收回调
 *
 *  @param messages 接收到的消息数组
 */
- (void)onReceiveMessage:(NSArray<V2NIMMessage *> *)messages;

@end

/// 消息更新监听协议
@protocol V2NIMMessageUpdateListener <NSObject>
@optional

/**
 *  消息更新回调
 *
 *  @param message 被更新的消息
 *  @param info 消息被更新的信息
 */
- (void)onMessageUpdated:(V2NIMMessage *)message
                    info:(V2NIMMessageUpdatedInfo *)info;

@end

/// 消息附件监听协议
@protocol V2NIMMessageAttachmentListener <NSObject>
@optional

/**
 *  消息附件上传回调
 *
 *  @param message 上传附件中的消息
 */
- (void)onUploadMessageAttachment:(V2NIMMessage *)message;

/**
 *  消息附件下载回调
 *
 *  @param message 下载附件中的消息
 */
- (void)onDownloadMessageAttachment:(V2NIMMessage *)message;

@end

/// 发送消息参数
@interface V2NIMSendMessageParam : NSObject

/// 消息配置
@property(nullable,nonatomic,strong,readwrite) V2NIMMessageConfig *messageConfig;
/// 推送设置
@property(nullable,nonatomic,strong,readwrite) V2NIMMessagePushOption *pushOption;
/// 反垃圾设置
@property(nullable,nonatomic,strong,readwrite) V2NIMMessageAntiSpamOption *antiSpamOption;
/// 环境变量，用于指向不同的抄送，第三方回调等配置
@property(nullable,nonatomic,strong,readwrite) NSString *env;

@end

/// 发送消息结果
@interface V2NIMSendMessageResult : NSObject

/// 第三方回调回来的自定义扩展
@property(nullable,nonatomic,strong,readonly) NSString *thirdPartyCallbackExtension;
/// 易盾反垃圾返回的结果
@property(nullable,nonatomic,strong,readonly) NSString *yidunAntiSpamResult;

@end

NS_ASSUME_NONNULL_END
