//
//  V2NIMMessageAttachmentCreator.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2023 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMPlatform.h"

@class V2NIMMessageAttachment;

NS_ASSUME_NONNULL_BEGIN

/// 消息状态
typedef NS_ENUM(NSInteger, V2NIMImageFormat) {
    V2NIM_IMAGE_FORMAT_JPEG                                   = 0,  ///< JPEG
    V2NIM_IMAGE_FORMAT_PNG                                    = 1,  ///< PNG
};

@interface V2NIMMessageAttachmentCreator : NSObject

/**
 *  创建图片消息附件
 *
 *  @param path 图片本地路径
 *
 *  @return 返回创建的图片消息附件
 */
+ (V2NIMMessageAttachment *)createImageAttachment:(NSString *)path;

/**
 *  创建语音消息附件
 *
 *  @param path 语音本地路径
 *
 *  @return 返回创建的语音消息附件
 */
+ (V2NIMMessageAttachment *)createAudioAttachment:(NSString *)path;

/**
 *  创建视频消息附件
 *
 *  @param path 视频本地路径
 *
 *  @return 返回创建的视频消息附件
 */
+ (V2NIMMessageAttachment *)createVideoAttachment:(NSString *)path;

/**
 *  创建文件消息附件
 *
 *  @param path 文件本地路径
 *
 *  @return 返回创建的文件消息附件
 */
+ (V2NIMMessageAttachment *)createFileAttachment:(NSString *)path;

/**
 *  创建地理位置消息附件
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param desc   地理位置描述
 *
 *  @return 返回创建的地理位置消息附件
 */
+ (V2NIMMessageAttachment *)createLocationAttachment:(double)longitude
                                            latitude:(double)latitude
                                                desc:(nullable NSString *)desc;

/**
 *  创建提示消息附件
 *
 *  @param attachment  附件内容
 *  @param callbackExtension   第三方回调回来的自定义扩展字段
 *
 *  @return 返回创建的提示消息附件
 */
+ (V2NIMMessageAttachment *)createTipAttachment:(nullable NSString *)attachment
                              callbackExtension:(nullable NSString *)callbackExtension;

/**
 *  创建图片消息附件
 *
 *  @param data 图片数据
 *  @param fileExt 图片文件扩展名
 *
 *  @return 返回创建的图片消息附件
 */
+ (V2NIMMessageAttachment *)createImageAttachmentWithData:(NSData *)data
                                                  fileExt:(nullable NSString *)fileExt;
/**
 *  创建图片消息附件
 *
 *  @param image UIImage图片对象
 *  @param format 保存的图片格式
 *  @param compressQuality 保存时使用的压缩质量（仅JPEG时有效），传值范围从0.0到1.0
 *
 *  @return compressQuality传值0.0认为是默认，默认按照0.5
 *
 *  @discussion 
 */
+ (V2NIMMessageAttachment *)createImageAttachmentWithImage:(UIImage *)image
                                                    format:(V2NIMImageFormat)format
                                           compressQuality:(float)compressQuality;

/**
 *  创建语音消息附件
 *
 *  @param data 语音数据
 *  @param fileExt 语音文件扩展名
 *
 *  @return 返回创建的语音消息附件
 */
+ (V2NIMMessageAttachment *)createAudioAttachmentWithData:(NSData *)data
                                                  fileExt:(nullable NSString *)fileExt;

/**
 *  创建视频消息附件
 *
 *  @param data 视频数据
 *  @param fileExt 视频文件扩展名
 *
 *  @return 返回创建的视频消息附件
 */
+ (V2NIMMessageAttachment *)createVideoAttachmentWithData:(NSData *)data
                                                  fileExt:(nullable NSString *)fileExt;

/**
 *  创建文件消息附件
 *
 *  @param data 文件数据
 *  @param fileExt 文件扩展名
 *
 *  @return 返回创建的视频消息附件
 */
+ (V2NIMMessageAttachment *)createFileAttachmentWithData:(NSData *)data
                                                 fileExt:(nullable NSString *)fileExt;

@end

NS_ASSUME_NONNULL_END
