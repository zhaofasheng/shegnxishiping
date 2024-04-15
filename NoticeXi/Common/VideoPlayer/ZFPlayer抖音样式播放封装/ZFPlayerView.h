
#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "ZFPlayerModel.h"
#import "SXPlayVideoFullControllView.h"
@class ZFPlayerView;


// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, ZFPlayerLayerGravity) {
    ZFPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    ZFPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    ZFPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};



// 播放器的几种状态
typedef NS_ENUM(NSInteger, ZFPlayerState) {
    ZFPlayerStateUnKonw,     // 未知状态
    ZFPlayerStatepPrepare,   // 准备播放
    ZFPlayerStateFailed,     // 播放失败
    ZFPlayerStateBuffering,  // 缓冲中
    ZFPlayerStatePlaying,    // 播放中
    ZFPlayerStateStopped,    // 播放结束
    ZFPlayerStatePause       // 暂停播放
};




@protocol ZFPlayerDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)zf_playerBackAction;
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url;
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen;
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen;
/** 视频播放结束 还需要做什么事 */
- (void)zf_playerFinished:(ZFPlayerModel *)model;
/** 播放下一首 */
- (void)zf_playerNextParter:(ZFPlayerModel *)model;
/** 播放到百分之几 */
- (void)zf_playerCurrentSliderValue:(NSInteger)value playerModel:(ZFPlayerModel *)model;
/** 播放状态发生改变 */
- (void)zf_playerPlayerStatusChange:(ZFPlayerState)statu;

//开始拖动进度
- (void)beginChangeVlue;
//结束拖动进度
- (void)endChangeVlue;


@end


@interface ZFPlayerView : UIView

@property (nonatomic, assign) BOOL isFirstAlloc;
/** playerLayer */
@property (nonatomic, strong) AVPlayerLayer          *playerLayer;
@property (nonatomic, strong) SXPlayVideoFullControllView                 *controlView;

@property (nonatomic, strong) ZFPlayerModel          *playerModel;
@property (nonatomic, strong) NSURL                  *videoURL;

//是否是竖屏
@property (nonatomic, assign) BOOL screen;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL                   isFullScreen;
/** 设置playerLayer的填充模式 */
@property (nonatomic, assign) ZFPlayerLayerGravity    playerLayerGravity;
/** 是否有下载功能(默认是关闭) */
@property (nonatomic, assign) BOOL                    hasDownload;
/** 是否开启预览图 */
@property (nonatomic, assign) BOOL                    hasPreviewView;
/** 设置代理 */
@property (nonatomic, weak) id<ZFPlayerDelegate>      delegate;

/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL          isPauseByUser;
/** 播发器的几种状态 */
@property (nonatomic, assign, readonly) ZFPlayerState state;

/** 当cell划出屏幕的时候停止播放（默认为NO） */
@property (nonatomic, assign) BOOL                    stopPlayWhileCellNotVisable;
/** 当cell播放视频由全屏变为小屏时候，是否回到中间位置(默认YES) */
@property (nonatomic, assign) BOOL                    cellPlayerOnCenter;
/** player在栈上，即此时push或者模态了新控制器 */
@property (nonatomic, assign) BOOL                    playerPushedOrPresented;

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 * 指定播放的控制层和模型
 * 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
 */
- (void)playerControlView:(UIView *)controlView playerModel:(ZFPlayerModel *)playerModel;

/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZFPlayerModel *)playerModel;

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZFPlayerModel *)playerModel;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;


/*
 * 非手动播放(不是用户主动点击继续播放)
 */
- (void)autoPlay;

/*
 *非手动暂停(不是用户点击暂停)
 */
- (void)autoPause;

//全屏播放
- (void)fullPlay;

//非全屏播放
- (void)nomerPlay;

//重新播放
- (void)_replayVideo;

- (void)removeObserver;
@end
