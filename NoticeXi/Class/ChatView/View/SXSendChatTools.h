//
//  SXSendChatTools.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXSendChatTools : NSObject

/// 发送图片消息
/// - Parameters:
///   - path: 图片路径
///   - success: 图片上传成功
///   - bucketId: bugketId
///   - imgData: 图片源文件

- (void)sendImgWithPath:(NSString *)path success:(BOOL)success bucketid:(NSString *)bucketId;

/// 发送表情包消息
/// - Parameters:
///   - path: 表情包路径
///   - bucketId: bucketid
///   - pictureId: 表情包id
///   - isHot: 是否是热门表情包

- (void)sendemtionWithPath:(NSString *)path bucketid:(NSString *)bucketId pictureId:(NSString *)pictureId isHot:(BOOL)isHot;


/// 发送语音消息
/// - Parameters:
///   - localPath: 语音本地源文件路径
///   - timeLength: 语音时长
///   - upSuccessPath: 语音上床成功后的url
///   - success: 语音是否上传成功
///   - bucketId: bucketid
///   - chatM: 引用消息，如果存在，代表是引用谁的消息
- (void)sendVocieWith:(NSString *)localPath time:(NSString *)timeLength upSuccessPath:(NSString *)upSuccessPath success:(BOOL)success bucketid:(NSString *)bucketId;


/// 发送文本消息
/// - Parameters:
///   - text: 文本内容
///   - chatM: 引用消息，如果存在，代表是引用谁的消息
- (void)sendTextWith:(NSString *)text;
@property (nonatomic, strong) NSMutableDictionary *sendOrderComDic;
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSString *orderId;
@end

NS_ASSUME_NONNULL_END
