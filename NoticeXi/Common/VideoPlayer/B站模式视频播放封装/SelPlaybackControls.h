//
//  SelBackControl.h
//  SelVideoPlayer
//
//  Created by 赵发生 on 2023/1/26.
//  Copyright © 2023年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelVideoSlider.h"
#import "SelPlayerConfiguration.h"
#import "SXScrollLabel.h"
#import "SXDragChangeValueView.h"
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

/** 播放器控制面板代理 */
@protocol SelPlaybackControlsDelegate <NSObject>

@required
/**
 播放按钮点击事件
 @param selected 按钮选中状态
 */
- (void)playButtonAction:(BOOL)selected;
/** 全屏切换按钮点击事件 */
- (void)fullScreenButtonAction;
- (void)retryButtonAction;
- (void)backButtonAction;
- (void)downloadAction;
/** 滑杆开始拖动 */
- (void)videoSliderTouchBegan:(SelVideoSlider *)slider;
/** 滑杆拖动中 */
- (void)videoSliderValueChanged:(SelVideoSlider *)slider;
/** 滑杆结束拖动 */
- (void)videoSliderTouchEnded:(SelVideoSlider *)slider;

/** pan开始水平移动 */
- (void)panHorizontalBeginMoved;
/** pan水平移动ing */
- (void)panHorizontalMoving:(CGFloat)value;
/** pan结束水平移动 */
- (void)panHorizontalEndMoved;

@optional
/** 控制面板单击事件 */
- (void)tapGesture;
/** 控制面板双击事件 */
- (void)doubleTapGesture;
/** 音量改变 */
- (void)volumeValueChange:(CGFloat)value;


@end

@interface SelPlaybackControls : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) SXDragChangeValueView *volumeProress;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *downloadBtn;
//是否是播放本地视频
@property (nonatomic, assign) BOOL isPlayLocalVideo;
/** 底部控制栏 */
@property (nonatomic, strong)UIView *bottomControlsBar;
/** 顶部控制栏 */
@property (nonatomic, strong)UIView *topControlsBar;
/** 播放按钮 */
@property (nonatomic, strong) UIButton *playButton;
/** 全屏切换按钮 */
@property (nonatomic, strong) UIButton *fullScreenButton;
/** 进度滑杆 */
@property (nonatomic, strong) SelVideoSlider *videoSlider;
/** 播放时间 */
@property (nonatomic, strong) UILabel *playTimeLabel;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progress;
/** 播放器控制面板代理 */
@property (nonatomic, weak) id<SelPlaybackControlsDelegate> delegate;
/** 隐藏控制面板延时时间 缺省5s */
@property (nonatomic, assign) NSTimeInterval hideInterval;
/** 是否处于全屏状态 */
@property (nonatomic, assign) BOOL isFullScreen;
/** 全屏状态下状态栏显示方式 */
@property (nonatomic, assign) SelStatusBarHideState statusBarHideState;
/** 加载指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
/** 加载失败重试按钮 */
@property (nonatomic, strong) UIButton *retryButton;

//上次播放位置
@property (nonatomic, strong) UILabel *lastPlayLocationLabel;

//流量播放提醒
@property (nonatomic, strong) UILabel *wanPlayLabel;

//快进、快退时间提示
@property (nonatomic, strong) UILabel *fastLabel;
/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection panDirection;
/** 滑动 */
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
/** 是否结束播放 */
@property (nonatomic, assign) BOOL playDidEnd;
//是否是竖屏
@property (nonatomic, assign) BOOL screen;
//是否是收费视频
@property (nonatomic, assign) BOOL isPay;
//上一次暂停是否是因为拖动
@property (nonatomic, assign) BOOL pauseIfForDrag;
//滚动文字
@property (nonatomic, strong) SXScrollLabel *scrollLabel;

/**
 设置视频时间显示以及滑杆状态
 @param playTime 当前播放时间
 @param totalTime 视频总时间
 @param sliderValue 滑杆滑动值
 */
- (void)_setPlaybackControlsWithPlayTime:(NSInteger)playTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue;

/** progress显示缓冲进度 */
- (void)_setPlayerProgress:(CGFloat)progress;
/** 显示或隐藏控制面板 */
- (void)_playerShowOrHidePlaybackControls;
/** 显示或隐藏状态栏 */
- (void)_showOrHideStatusBar;
/** 取消延时隐藏playbackControls */
- (void)_playerCancelAutoHidePlaybackControls;
/** 延时自动隐藏控制面板 */
- (void)_playerAutoHidePlaybackControls;
/** 显示或隐藏加载指示器 */
- (void)_activityIndicatorViewShow:(BOOL)show;
/** 控制播放按钮选择状态 */
- (void)_setPlayButtonSelect:(BOOL)select;
/** 显示或隐藏重新加载按钮 */
- (void)_retryButtonShow:(BOOL)show;

- (void)makeConstraints;


/** 开始拖动事件 */
- (void)progressSliderTouchBegan:(SelVideoSlider *)slider;
/** 拖动中事件 */
- (void)progressSliderValueChanged:(SelVideoSlider *)slider;
/** 结束拖动事件 */
- (void)progressSliderTouchEnded:(SelVideoSlider *)slider;
@end
