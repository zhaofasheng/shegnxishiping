//
//  SelPlayerConfiguration.h
//  SelVideoPlayer
//
//  Created by 赵发生 on 2023/1/26.
//  Copyright © 2023年 赵发生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 视频拉伸方式 */
typedef NS_ENUM(NSUInteger, SelVideoGravity){
    SelVideoGravityResize,       //非均匀拉伸。两个维度完全填充至整个视图区域
    SelVideoGravityResizeAspect,     //等比例拉伸，直到一个维度到达区域边界
    SelVideoGravityResizeAspectFill, //等比例拉伸，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

/** 全屏状态下状态栏显示方式 */
typedef NS_ENUM(NSInteger, SelStatusBarHideState)
{
    SelStatusBarHideStateFollowControls = 0, //跟随控制面板显示
    SelStatusBarHideStateNever, //从不显示
    SelStatusBarHideStateAlways, //一直显示
};

@interface SelPlayerConfiguration : NSObject
//倍速
@property (nonatomic, assign) NSInteger rate;
//是否是收费视频
@property (nonatomic, assign) BOOL isPay;
/** 视频数据源 */
@property (nonatomic, strong) NSURL *sourceUrl;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL shouldAutoPlay;
//是否是竖屏
@property (nonatomic, assign) BOOL screen;
//是否是播放本地视频
@property (nonatomic, assign) BOOL isPlayLocalVideo;
/** 视频拉伸方式 */
@property (nonatomic, assign) SelVideoGravity videoGravity;
/** 是否重复播放 */
@property (nonatomic, assign) BOOL repeatPlay;
/** 是否支持双击暂停或播放 */
@property (nonatomic, assign) BOOL supportedDoubleTap;
/** 是否支持自动转屏 */
@property (nonatomic, assign) BOOL shouldAutorotate;
/** 隐藏控制面板延时时间 缺省5s */
@property (nonatomic, assign) NSTimeInterval hideControlsInterval;
/** 全屏状态下状态栏显示方式 */
@property (nonatomic, assign) SelStatusBarHideState statusBarHideState;
@property (nonatomic, assign) BOOL justShow;
/** 是否自动全屏 */
@property (nonatomic, assign) BOOL isAutoFull;
//从什么位置开始播放
@property (nonatomic, assign) CGFloat defalutPlayTime;

@property (nonatomic, assign) BOOL isTryPlay;
@property (nonatomic, assign) BOOL noLock;

@end
