//
//  SelVideoPlayer.h
//  SelVideoPlayer
//
//  Created by 赵发生 on 2023/1/26.
//  Copyright © 2023年 赵发生. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SelPlayerConfiguration.h"
#import "SelPlaybackControls.h"


@class SelPlayerConfiguration;

@interface SelVideoPlayer : UIView

/**
 初始化播放器
 @param configuration 播放器配置信息
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(SelPlayerConfiguration *)configuration;
@property (nonatomic,copy) void(^currentPlayTimeBlock)(NSInteger currentTime);
@property (nonatomic,copy) void(^playDidEndBlock)(BOOL playDidEnd);
@property (nonatomic,copy) void(^backPopBlock)(BOOL back);
@property (nonatomic,copy) void(^downVideoBlock)(BOOL download);
/** 播放器 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 播放器item */
@property (nonatomic, strong) AVPlayer *player;
/** 播放器layer */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/** 是否播放完毕 */
@property (nonatomic, assign) BOOL isFinish;
/** 是否处于全屏状态 */
@property (nonatomic, assign) BOOL isFullScreen;
/** 是否设置了默认播放进度 */
@property (nonatomic, assign) BOOL isSetDefaultPlaytime;
/** 播放器配置信息 */
@property (nonatomic, strong) SelPlayerConfiguration *playerConfiguration;
/** 视频播放控制面板 */
@property (nonatomic, strong) SelPlaybackControls *playbackControls;

/** 是否结束播放 */
@property (nonatomic, assign) BOOL playDidEnd;
//是否是竖屏
@property (nonatomic, assign) BOOL screen;
//是否是播放本地视频
@property (nonatomic, assign) BOOL isPlayLocalVideo;
//是否是收费视频
@property (nonatomic, assign) BOOL isPay;
//仅显示，不提供播放
- (void)setPlayerSource;
@property (nonatomic, strong) UIView *fullView;
/** 播放视频 */
- (void)_playVideo;
/** 暂停播放 */
- (void)_pauseVideo;
/** 释放播放器 */
- (void)_deallocPlayer;
- (void)deallocAll;

- (void)refreshUI;
@end
