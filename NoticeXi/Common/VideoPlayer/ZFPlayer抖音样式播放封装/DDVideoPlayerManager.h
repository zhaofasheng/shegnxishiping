//
//  DDVideoPlayerManager.h
//  DuoDUoAnimateHouse
//
//  Created by 唐天成 on 2018/5/10.
//  Copyright © 2018年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFPlayer.h"


@protocol ZFManagerPlayerDelegate <NSObject>

@optional
/** 返回按钮事件 */
- (void)zfManager_playerBackAction;
/** 下载视频 */
- (void)zfManager_playerDownload:(NSString *_Nullable)url;
/** 控制层即将显示 */
- (void)zfManager_playerControlViewWillShow:(UIView *_Nullable)controlView isFullscreen:(BOOL)fullscreen;
/** 控制层即将隐藏 */
- (void)zfManager_playerControlViewWillHidden:(UIView *_Nullable)controlView isFullscreen:(BOOL)fullscreen;
/** 视频播放结束 还需要做什么事 */
- (void)zfManager_playerFinished:(ZFPlayerModel *_Nullable)model;
/** 播放下一首 */
- (void)zfManager_playerNextParter:(ZFPlayerModel *_Nullable)model;
/** 播放到百分之几 */
- (void)zfManager_playerCurrentSliderValue:(NSInteger)value playerModel:(ZFPlayerModel *_Nonnull)model;
/** 播放状态发生改变 */
- (void)zfManager_playerPlayerStatusChange:(ZFPlayerState)statu;
/** 前往小视频播放界面 */
- (void)zfManager_playerPushToPlaySmallViewListVC;

@end


@interface DDVideoPlayerManager : NSObject


//原始的(http)网络路径
@property (nonatomic, strong) NSURL * _Nullable originVideoURL;

/** 播放器View的父视图*/
@property (strong, nonatomic, readonly) ZFPlayerView * _Nullable playerView;
@property(nonatomic, strong, readonly) ZFPlayerModel * _Nullable playerModel;
@property (nonatomic, weak) id<ZFManagerPlayerDelegate> _Nullable managerDelegate;

@property (nonatomic, assign) BOOL noReplay;//当前不允许自动播放
/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/*
 * 非手动播放
 */
- (void)autoPlay;

/*
 *非手动暂停
 */
- (void)autoPause;

/**
 *  重置player
 */
- (void)resetPlayer;



/**
 在当前页面，设置新的视频时候调用此方法


 @param playNowRealType YES的话 model里的是网络地址就播放网络地址,是本地地址就播放本地地址,NO则会去查一下是否本地已经缓存了这个网络地址,主要给iOS11以下用的

 */
- (void)resetToPlayNewVideo;//WithplayNowRealType:(BOOL)playNowRealType;



/**
 * Return the cache key for a given URL.
 */
- (NSString *_Nullable)cacheKeyForURL:(NSURL *_Nullable)url;

@end
