//
//  V2NIMMessage.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2023 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "V2NIMMessageEnum.h"

@protocol V2NIMMessageAttachment;

@class V2NIMMessagePushOption;
@class V2NIMMessageRefer;

@class V2NIMMessageConfig;
@class V2NIMMessageAntiSpamOption;
@class V2NIMMessageUpdatedInfo;

NS_ASSUME_NONNULL_BEGIN

/// 消息对象
@interface V2NIMMessage : NSObject <NSCopying>

/// 消息所属的会话
@property(nullable,nonatomic,strong,readonly) NSString *conversationId;
/// 客户端消息id
@property(nonatomic,strong,readonly) NSString *clientId;
/// 服务端消息id
@property(nullable,nonatomic,strong,readonly) NSString *serverId;
/// 时间
@property(nonatomic,assign,readonly) NSTimeInterval time;
/// 发送方账号id
@property(nullable,nonatomic,strong,readonly) NSString *senderAccountId;

/// 类型
@property(nonatomic,assign,readonly) V2NIMMessageType type;
/// 子类型
@property(nonatomic,assign,readonly) NSInteger subType;
/// 文本
@property(nullable,nonatomic,strong,readwrite) NSString *text;
/// 附件
@property(nullable,nonatomic,strong,readwrite) id<V2NIMMessageAttachment> attachment;
/// 服务端扩展信息
@property(nullable,nonatomic,strong,readwrite) NSString *serverExtension;
/// 客户端本地扩展信息
@property(nullable,nonatomic,strong,readwrite) NSString *localExtension;

/// 发送状态
@property(nonatomic,assign,readonly) V2NIMMessageSendState sendState;
/// 附件上传状态
@property(nonatomic,assign,readonly) V2NIMMessageAttachmentUploadState attachmentUploadState;
/// 附件下载状态
@property(nonatomic,assign,readonly) V2NIMMessageAttachmentDownloadState attachmentDownloadState;
/// 状态
@property(nonatomic,assign,readonly) V2NIMMessageState state;

/// 推送设置
@property(nullable,nonatomic,strong,readonly) V2NIMMessagePushOption *pushOption;

/// 回复消息引用
@property(nullable,nonatomic,strong,readonly) V2NIMMessageRefer *replyRefer;
/// Thread消息引用
@property(nullable,nonatomic,strong,readonly) V2NIMMessageRefer *threadRefer;

/**
 *  标记消息被客户端反垃圾拦截
 *
 *  @discussion 当使用客户端反垃圾检查，如果检查结果为“服务器拦截”，可通过此方法标记。标记后，此消息可以发送成功，但接收方不会收到。
 */- (void)markAntiSpamIntercepted;

@end

/// 消息推送设置
@interface V2NIMMessagePushOption : NSObject <NSCopying>

/// 推送文本
@property(nullable,nonatomic,strong,readwrite) NSString *content;
/// 推送数据
@property(nullable,nonatomic,strong,readwrite) NSString *payload;

/// 是否强制推送
@property(nonatomic,assign,readwrite) BOOL forcePush;
/// 强制推送文本
@property(nullable,nonatomic,strong,readwrite) NSString *forcePushContent;
/// 强制推送目标账号列表
@property(nullable,nonatomic,strong,readwrite) NSArray<NSString *> *forcePushAccountIds;

@end

/// 消息引用
@interface V2NIMMessageRefer : NSObject <NSCopying>

/// 发送方账号id
@property(nonatomic,strong,readonly) NSString *senderAccountId;
/// 接收方账号id
@property(nonatomic,strong,readonly) NSString *receiverAccountId;
/// 客户端消息id
@property(nonatomic,strong,readonly) NSString *clientId;
/// 服务端消息id
@property(nonatomic,strong,readonly) NSString *serverId;
/// 时间
@property(nonatomic,assign,readonly) NSTimeInterval time;

@end

/// 消息配置
@interface V2NIMMessageConfig : NSObject <NSCopying>

/// 是否不需要在服务端保存历史消息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL historyDisabled;
/// 是否不需要漫游消息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL roamingDisabled;
/// 是否不需要离线消息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL offlineDisabled;
/// 是否不需要发送方多端在线同步消息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL senderSyncDisabled;
/// 是否不需要更新消息所属的会话信息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL conversationUpdateDisabled;

/// 是否不需要推送消息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL pushDisabled;
/// 是否不需要推送消息未读角标计数。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL pushBadgeDisabled;
/// 是否不需要推送消息发送者昵称。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL pushNickDisabled;

/// 是否需要群消息已读回执信息。YES：需要，NO：不需要，默认NO：不需要
@property(nonatomic,assign,readwrite) BOOL teamReceiptEnabled;

/// 是否不需要路由消息。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL routeDisabled;

@end

/// 消息反垃圾设置
@interface V2NIMMessageAntiSpamOption : NSObject <NSCopying>

/// 易盾反作弊（辅助检测数据），json格式，限制长度1024
@property(nullable,nonatomic,strong,readwrite) NSString *yidunAntiCheating;
/// 易盾反垃圾（辅助检测数据），json格式，限制长度1024
@property(nullable,nonatomic,strong,readwrite) NSString *yidunAntiSpam;

/// 自定义消息中需要反垃圾的内容（仅当消息类型为自定义消息时有效）
@property(nullable,nonatomic,strong,readwrite) NSString *customMessageAntiSpamContent;

/// 指定易盾业务id，而不使用云信后台配置的
@property(nullable,nonatomic,strong,readwrite) NSString *yidunBusinessId;
/// 指定不需要易盾反垃圾（仅开通易盾时有效）。YES：不需要，NO：需要，默认NO：需要
@property(nonatomic,assign,readwrite) BOOL yidunAntiSpamDisabled;

@end

/// 消息被更新信息
@interface V2NIMMessageUpdatedInfo : NSObject <NSCopying>

/// 状态
@property(nonatomic,assign,readonly) V2NIMMessageState state;
/// 服务端扩展信息
@property(nullable,nonatomic,strong,readwrite) NSString *serverExtension;
/// 客户端本地扩展信息
@property(nullable,nonatomic,strong,readwrite) NSString *localExtension;

@end

NS_ASSUME_NONNULL_END
