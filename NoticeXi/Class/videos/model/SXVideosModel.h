//
//  SXVideosModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXUserModel.h"
#import "SXPayForVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXVideosModel : NSObject

@property (nonatomic, copy) NSString *vid;                  // 文件唯一id标识

@property (nonatomic, assign) CGFloat nomerHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSMutableAttributedString *titleAttStr;

@property (nonatomic, strong) NSString *introduce;//视频简介
@property (nonatomic, assign) CGFloat introHeight;
@property (nonatomic, strong) NSMutableAttributedString *introAttStr;
@property (nonatomic, strong) NSString *title;//视频标题
@property (nonatomic, strong) NSString *sell_series_id;//推荐课程id
@property (nonatomic, strong) NSString *series_name;//推荐课程名称
@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *video_url;//视频标题
@property (nonatomic, strong) NSString *video_len;//视频时长(单位秒)
@property (nonatomic, strong) NSString *video_download_url;//视频下载地址
@property (nonatomic, strong) NSString *screen;//屏幕信息 0未知 1横屏 2竖屏
@property (nonatomic, strong) NSString *video_cover_url;//视频封面
@property (nonatomic, strong) NSString *series_images;
@property (nonatomic, strong) NSDictionary *user_info;//用户信息
@property (nonatomic, strong) SXUserModel  *userModel;
/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger    seekTime;

@property (nonatomic, strong) NSString *first_frame_url;//第一帧图片

@property (nonatomic, strong) NSString *commentCt;//视频评论数量
@property (nonatomic, strong) NSString *series_id;//课程id
//内容是否展开（默认不设置，都是NO，收起状态）
@property (nonatomic, assign) BOOL isOpen;

//是否正在拖动进度
@property (nonatomic, assign) BOOL isDraging;

@property (nonatomic, strong) SXPayForVideoModel *tuijianStudyModel;

@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSString *showText;

@property (nonatomic, strong) NSString *qqShareUrl;
@property (nonatomic, strong) NSString *wechatShareUrl;

@property (nonatomic, strong) NSString *is_zan;//是否点在 1点赞 0无
@property (nonatomic, strong) NSString *zan_num;//点赞数量
@property (nonatomic, strong) NSString *is_collection;//是否收藏 1收藏 0无
@property (nonatomic, strong) NSString *collection_num;//收藏数量

@property (nonatomic, strong) NSDictionary *series_info;
@property (nonatomic, strong) SXPayForVideoModel *searModel;

@property (nonatomic, strong) NSString *schedule;//播放进度
@property (nonatomic, strong) NSString *is_finished;//播放完成

@property (nonatomic, strong) NSString *webBuyUrl;

@property (nonatomic, strong) NSString *compilation_id;//合集id
@property (nonatomic, strong) NSString *compilation_name;//合集名称
@end

NS_ASSUME_NONNULL_END
