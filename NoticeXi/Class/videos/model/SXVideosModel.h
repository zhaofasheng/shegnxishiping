//
//  SXVideosModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXUserModel.h"
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
@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *video_url;//视频标题
@property (nonatomic, strong) NSString *video_len;//视频时长(单位秒)
@property (nonatomic, strong) NSString *video_download_url;//视频下载地址
@property (nonatomic, strong) NSString *screen;//屏幕信息 0未知 1横屏 2竖屏
@property (nonatomic, strong) NSString *video_cover_url;//视频封面
@property (nonatomic, strong) NSDictionary *user_info;//用户信息
@property (nonatomic, strong) SXUserModel  *userModel;
/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger    seekTime;

@property (nonatomic, strong) NSString *first_frame_url;//第一帧图片



//内容是否展开（默认不设置，都是NO，收起状态）
@property (nonatomic, assign) BOOL isOpen;

//是否正在拖动进度
@property (nonatomic, assign) BOOL isDraging;

@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSAttributedString *fiveAttTextStr;
@property (nonatomic, assign) BOOL isMoreFiveLines;//是否超过五行文字
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSString *showText;
@end

NS_ASSUME_NONNULL_END
