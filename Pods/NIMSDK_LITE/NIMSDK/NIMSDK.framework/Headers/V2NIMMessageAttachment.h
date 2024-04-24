//
//  V2NIMMessageAttachment.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2023 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "V2NIMMessageEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class V2NIMMessage;

/// 消息附件协议
@protocol V2NIMMessageAttachment <NSObject>

/// 消息类型
@property(nonatomic,assign,readonly) V2NIMMessageType type;
/// 消息对象
@property(nullable,nonatomic,weak,readonly) V2NIMMessage *message;

@end

/// 消息存储附件协议
@protocol V2NIMMessageStorageAttachment <V2NIMMessageAttachment>

/// 上传状态
@property(nonatomic,assign,readonly) V2NIMMessageAttachmentUploadState uploadState;
/// 下载状态
@property(nonatomic,assign,readonly) V2NIMMessageAttachmentDownloadState downloadState;

/// 存储url
@property(nullable,nonatomic,copy,readonly) NSString *url;
/// 本地路径
@property(nullable,nonatomic,copy,readonly) NSString *path;

/**
 *  提供已上传的存储url（可以不通过云信上传）
 *
 *  @param url 存储url
 *
 *  @discussion 可以不使用云信上传，或者先通过云信提供的上传接口上传，获得到存储url后通过此接口进行设置，在消息发送中，云信将不会上传这个附件，而是只是发送消息
 */
- (void)provideUrl:(NSString *)url;

/**
 *  设置NOS场景（仅上传到云信NOS有效）
 *
 *  @param scene 场景值
 *
 *  @discussion
 */
- (void)setNOSScene:(NSString *)scene;

@end

/// 消息图片附件
@interface V2NIMMessageImageAttachment : NSObject <V2NIMMessageStorageAttachment>

/// 图片数据md5
@property(nullable,nonatomic,copy,readonly) NSString *md5;
/// 图片数据大小
@property(nonatomic,assign,readonly) int dataSize;

/// 图片宽度
@property(nonatomic,assign,readonly) int width;
/// 图片高度
@property(nonatomic,assign,readonly) int height;

/// 描述信息
@property(nullable,nonatomic,copy,readwrite) NSString *desc;

/// 缩略图url（仅通过云信上传才提供）
@property(nullable,nonatomic,copy,readonly) NSString *thumbUrl;
/// 缩略图本地路径（仅通过云信上传才提供）
@property(nullable,nonatomic,copy,readonly) NSString *thumbPath;

/**
 *  设置NOS场景（仅上传到云信NOS有效）
 *
 *  @param width 图片宽
 *  @param height 图片高
 *
 *  @discussion 使用此方法可以设置或覆盖图片尺寸
 */
- (void)setImageSize:(int)width
              height:(int)height;

@end

/// 消息语音附件
@interface V2NIMMessageAudioAttachment : NSObject <V2NIMMessageStorageAttachment>

/// 语音数据md5
@property(nullable,nonatomic,copy,readonly) NSString *md5;
/// 语音数据大小
@property(nonatomic,assign,readonly) int dataSize;

/// 语音长度（毫秒）当创建附件时，SDK会解析语音长度，但可以被覆盖
@property(nonatomic,assign,readwrite) int duration;

/// 描述信息
@property(nullable,nonatomic,copy,readwrite) NSString *desc;

@end

/// 消息视频附件
@interface V2NIMMessageVideoAttachment : NSObject <V2NIMMessageStorageAttachment>

/// 视频数据md5
@property(nullable,nonatomic,copy,readonly) NSString *md5;
/// 视频数据大小
@property(nonatomic,assign,readonly) int dataSize;

/// 视频长度（毫秒）当创建附件时，SDK会解析视频长度，但可以被覆盖
@property(nonatomic,assign,readwrite) int duration;

/// 描述信息
@property(nullable,nonatomic,copy,readwrite) NSString *desc;

/// 视频缩略图宽度
@property(nonatomic,assign,readonly) int thumbWidth;
/// 视频缩略图高度
@property(nonatomic,assign,readonly) int thumbHeight;

/// 视频缩略图url（仅通过云信上传才提供）
@property(nullable,nonatomic,copy,readonly) NSString *thumbUrl;
/// 视频缩略图本地路径（仅通过云信上传才提供）
@property(nullable,nonatomic,copy,readonly) NSString *thumbPath;

/// 视频宽度
@property(nonatomic,assign,readonly) int videoWidth;
/// 视频高度
@property(nonatomic,assign,readonly) int videoHeight;

@end

/// 消息文件附件
@interface V2NIMMessageFileAttachment : NSObject <V2NIMMessageStorageAttachment>

/// 文件数据md5
@property(nullable,nonatomic,copy,readonly) NSString *md5;
/// 文件数据大小
@property(nonatomic,assign,readonly) int dataSize;

/// 描述信息（如果是从本地路径创建的文件附件，此字段自动填入文件名）
@property(nullable,nonatomic,copy,readwrite) NSString *desc;

@end

/// 消息地理位置附件
@interface V2NIMMessageLocationAttachment : NSObject <V2NIMMessageAttachment>

/// 经度
@property(nonatomic,assign,readonly) double longitude;
/// 纬度
@property(nonatomic,assign,readonly) double latitude;
/// 地理位置描述信息
@property(nullable,nonatomic,copy,readonly) NSString *desc;

@end

/// 消息提醒附件
@interface V2NIMMessageTipAttachment : NSObject <V2NIMMessageAttachment>

/// 附件内容
@property(nullable,nonatomic,copy,readonly) NSString *attachment;
/// 第三方回调回来的自定义扩展字段
@property(nullable,nonatomic,copy,readonly) NSString *callbackExtension;

@end

/// 消息机器人附件
@interface V2NIMMessageRobotAttachment : NSObject <V2NIMMessageAttachment>

@end

/// 消息话单附件
@interface V2NIMMessageCallAttachment : NSObject <V2NIMMessageAttachment>

@end

NS_ASSUME_NONNULL_END
