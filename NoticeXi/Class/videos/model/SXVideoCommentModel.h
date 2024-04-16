//
//  SXVideoCommentModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCommentModel : NSObject

@property (nonatomic, strong) NSString *commentId;//评论id
@property (nonatomic, strong) NSString *video_id;//视频ID
@property (nonatomic, strong) NSString *content;//评论内容
@property (nonatomic, strong) NSString *from_user_id;//评论人ID
@property (nonatomic, strong) NSString *to_user_id;//被评论人ID
@property (nonatomic, strong) NSString *post_id;//0=一级评论 实际回复ID
@property (nonatomic, strong) NSString *be_reply_status;//0：未回复,1：已被回复
@property (nonatomic, strong) NSString *reply_num;//单条评论回复数量
@property (nonatomic, strong) NSString *reply_ctnum;//展开回复总数
@property (nonatomic, strong) NSString *zan_num;//点赞数量
@property (nonatomic, strong) NSString *comment_type;//类型1=文字2图片3=gif动态图片4=待定其它
@property (nonatomic, strong) NSString *comment_status;//1：正常，2：用户删除，3：管理员删除
@property (nonatomic, strong) NSString *is_like;//1=点赞 0=没有点赞
@property (nonatomic, strong) NSString *created_at;//创建时间

@property (nonatomic, strong) NSDictionary *from_user;//评论人信息
@property (nonatomic, strong) SXUserModel *fromUserInfo;

@property (nonatomic, strong) NSDictionary *to_user;//被回复人信息
@property (nonatomic, strong) SXUserModel *toUserInfo;

@property (nonatomic, strong) NSDictionary *reply;//第一条回复数据
@property (nonatomic, strong) SXVideoCommentModel *firstReplyModel;//回复数组 非定位列表和正常列表的时候都可能有这个

@property (nonatomic, strong) NSDictionary *comment;//第一条评论数据 定位的时候才存在
@property (nonatomic, strong) SXVideoCommentModel *firstCommentModel;//第一条评论数据 定位的时候才存在
@end

NS_ASSUME_NONNULL_END
