//
//  V2NIMMessageEnum.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2023 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 消息类型
typedef NS_ENUM(NSInteger, V2NIMMessageType) {
    V2NIM_MESSAGE_TYPE_TEXT                                   = 0,  ///< 文本
    V2NIM_MESSAGE_TYPE_IMAGE                                  = 1,  ///< 图片
    V2NIM_MESSAGE_TYPE_AUDIO                                  = 2,  ///< 语音
    V2NIM_MESSAGE_TYPE_VIDEO                                  = 3,  ///< 视频
    V2NIM_MESSAGE_TYPE_LOCATION                               = 4,  ///< 地理位置
    V2NIM_MESSAGE_TYPE_NOTIFICATION                           = 5,  ///< 通知
    V2NIM_MESSAGE_TYPE_FILE                                   = 6,  ///< 文件
    V2NIM_MESSAGE_TYPE_TIP                                    = 10,  ///< 提醒
    V2NIM_MESSAGE_TYPE_ROBOT                                  = 11,  ///< 机器人
    V2NIM_MESSAGE_TYPE_CALL                                   = 12,  ///< 话单
    V2NIM_MESSAGE_TYPE_CUSTOM                                 = 100,  ///< 自定义
};

/// 消息状态
typedef NS_ENUM(NSInteger, V2NIMMessageState) {
    V2NIM_MESSAGE_STATE_DEFAULT                               = 0,  ///< 默认
    V2NIM_MESSAGE_STATE_DELETED                               = 1,  ///< 已删除
    V2NIM_MESSAGE_STATE_REVOKED                               = 2,  ///< 已撤回
};

/// 消息发送状态
typedef NS_ENUM(NSInteger, V2NIMMessageSendState) {
    V2NIM_MESSAGE_SEND_STATE_UNKNOWN                          = 0,  ///< 未知
    V2NIM_MESSAGE_SEND_STATE_SENT                             = 1,  ///< 已发送
    V2NIM_MESSAGE_SEND_STATE_FAILED                           = 2,  ///< 发送失败
    V2NIM_MESSAGE_SEND_STATE_SENDING                          = 3,  ///< 发送中
};

/// 消息附件上传状态
typedef NS_ENUM(NSInteger, V2NIMMessageAttachmentUploadState) {
    V2NIM_MESSAGE_ATTACHMENT_UPLOAD_STATE_UNKNOWN             = 0,  ///< 未知
    V2NIM_MESSAGE_ATTACHMENT_UPLOAD_STATE_SUCCEED             = 1,  ///< 上传成功
    V2NIM_MESSAGE_ATTACHMENT_UPLOAD_STATE_FAILED              = 2,  ///< 上传失败
    V2NIM_MESSAGE_ATTACHMENT_UPLOAD_STATE_UPLOADING           = 3,  ///< 上传中
};

/// 消息附件下载状态
typedef NS_ENUM(NSInteger, V2NIMMessageAttachmentDownloadState) {
    V2NIM_MESSAGE_ATTACHMENT_DOWNLOAD_STATE_UNKNOWN           = 0,  ///< 未知
    V2NIM_MESSAGE_ATTACHMENT_DOWNLOAD_STATE_SUCCEED           = 1,  ///< 下载成功
    V2NIM_MESSAGE_ATTACHMENT_DOWNLOAD_STATE_FAILED            = 2,  ///< 下载失败
    V2NIM_MESSAGE_ATTACHMENT_DOWNLOAD_STATE_DOWNLOADING       = 3,  ///< 下载中
};

NS_ASSUME_NONNULL_END
