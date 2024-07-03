    //
//  SelVideoPlayer.m
//  SelVideoPlayer
//
//  Created by 赵发生 on 2023/1/26.
//  Copyright © 2023年 赵发生. All rights reserved.
//

#import "SelVideoPlayer.h"
#import <MediaPlayer/MPVolumeView.h>
#import "KTVHCDataUnitPool.h"
#import "KTVHTTPCache.h"
/** 播放器的播放状态 */
typedef NS_ENUM(NSInteger, SelVideoPlayerState) {
    SelVideoPlayerStateFailed,     // 播放失败
    SelVideoPlayerStateBuffering,  // 缓冲中
    SelVideoPlayerStatePlaying,    // 播放中
    SelVideoPlayerStatePause,      // 暂停播放
};

@interface SelVideoPlayer()<SelPlaybackControlsDelegate,AVPictureInPictureControllerDelegate>



/** 非全屏状态下播放器 superview */
@property (nonatomic, strong) UIView *originalSuperview;
/** 非全屏状态下播放器 frame */
@property (nonatomic, assign) CGRect originalRect;
/** 时间监听器 */
@property (nonatomic, strong) id timeObserve;
/** 播放器的播放状态 */
@property (nonatomic, assign) SelVideoPlayerState playerState;

/** 声音滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

/** 用来保存pan手势快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
@property (nonatomic, assign) NSInteger setRateTime;
@property (nonatomic, strong) XLAlertView *alerView;

@property (nonatomic, assign) BOOL hasShowActivity;
@property (nonatomic, assign) BOOL needSetRate;
@end

@implementation SelVideoPlayer

/**
 初始化播放器
 @param configuration 播放器配置信息
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(SelPlayerConfiguration *)configuration
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasShowActivity = YES;
        self.isAutoFull = configuration.isAutoFull;
        _playerConfiguration = configuration;
        self.isPay = configuration.isPay;
        self.screen = configuration.screen;
        self.isPlayLocalVideo = configuration.isPlayLocalVideo;
        if (configuration.defalutPlayTime > 0) {
            self.isSetDefaultPlaytime = YES;
        }else{
            self.isSetDefaultPlaytime = NO;
        }
        if (!configuration.justShow) {
            self.rate = configuration.rate;
            [self _setupPlayer];
            [self _setupPlayControls];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(appDidEnterBackground:)
                                                         name:UIApplicationWillResignActiveNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(appDidEnterPlayground:)
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
            
            //监听耳机的插拔
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
            //来了语音通话
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlay) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
            if (@available(iOS 11.0, *)) {
                // 检测到当前设备录屏状态发生变化
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenCaptureStatusChanged:) name:UIScreenCapturedDidChangeNotification object:nil];
            }
        }

    }
    return self;
}

- (void)screenCaptureStatusChanged:(NSNotification *)notification {
    if (!self.isPay) {
        return;
    }
    UIScreen *screen = notification.object;
    if (screen.isCaptured) {
        // 屏幕正在录制中
        DRLog(@"正在录屏");
        [self screenshots];
    } else {
        [self _playVideo];
        DRLog(@"没有录屏");
    }
}

//用户录屏的时候暂停播放视频
- (void)screenshots{
    [self _pauseVideo];
    [self.alerView removeFromSuperview];
    [self.alerView showXLAlertView];

}

/** 屏幕翻转监听事件 */
- (void)orientationChanged:(NSNotification *)notify
{
    if (_playerConfiguration.shouldAutorotate) {
        [self orientationAspect];
    }
}

/** 根据屏幕旋转方向改变当前视频屏幕状态 */
- (void)orientationAspect
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft){
        if (!_isFullScreen){
           [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeRight];
        }
    }
    else if (orientation == UIDeviceOrientationLandscapeRight){
        if (!_isFullScreen){
           [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeLeft];
        }
    }
    else if(orientation == UIDeviceOrientationPortrait){
        if (_isFullScreen){
            [self _videoZoomOut];
        }
    }
}

/**
 视频放大全屏幕
 @param orientation 旋转方向
 */
- (void)_videoZoomInWithDirection:(UIInterfaceOrientation)orientation
{
    _originalSuperview = self.superview;
    _originalRect = self.frame;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.fullView];
    [self.fullView addSubview:self];
    
    if (!self.screen) {
        if (self.isAutoFull) {
            if (orientation == UIInterfaceOrientationLandscapeLeft){
                self.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }else if (orientation == UIInterfaceOrientationLandscapeRight) {
                self.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
            self.isAutoFull = NO;
        }else{
            CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
            [UIView animateWithDuration:duration animations:^{
                if (orientation == UIInterfaceOrientationLandscapeLeft){
                    self.transform = CGAffineTransformMakeRotation(-M_PI/2);
                }else if (orientation == UIInterfaceOrientationLandscapeRight) {
                    self.transform = CGAffineTransformMakeRotation(M_PI/2);
                }
            }completion:^(BOOL finished) {
                
            }];
        }
    
 
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    }else{
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    }
    
    self.isFullScreen = YES;
    [self refreshUI];
}

- (UIView *)fullView{
    if (!_fullView) {
        _fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _fullView.backgroundColor = [UIColor blackColor];
    }
    return _fullView;
}

/** 视频退出全屏幕 */
- (void)_videoZoomOut
{
   
    [_fullView removeFromSuperview];
    if (!self.screen) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }completion:^(BOOL finished) {
            
        }];
    }
 
    self.frame = _originalRect;
    [_originalSuperview addSubview:self];
    

    self.isFullScreen = NO;
    [self refreshUI];
}

/** 播放视频 */
- (void)_playVideo
{
    DRLog(@"播放视频");
    AVAudioSession*session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    UIScreen *screen =[UIScreen mainScreen];
   
    if (screen.isCaptured && self.isPay) {//用户正在录屏
        DRLog(@"正在录屏");
        [self.alerView removeFromSuperview];
        [self.alerView showXLAlertView];
        return;
    }

    if (self.playDidEnd && self.playbackControls.videoSlider.value == 1.0) {
        //若播放已结束重新播放
        [self _replayVideo];
    }else
    {
        self.playbackControls.playButton.hidden = YES;
        [_player play];
        
        [self.playbackControls _setPlayButtonSelect:YES];
        if (self.playerState == SelVideoPlayerStatePause) {
            self.playerState = SelVideoPlayerStatePlaying;
        }
        
    }
}

- (void)playrateset{
    if (self.playerState != SelVideoPlayerStatePlaying) {
        return;
    }
    DRLog(@"设置倍速");
    if (self.rate == 1) {
        _player.rate = 1.0;
    }else if (self.rate == 2){
        _player.rate = 1.25;
    }else if (self.rate == 3){
        _player.rate = 1.5;
    }else if (self.rate == 4){
        _player.rate = 2.0;
    }
}

/** 暂停播放 */
- (void)_pauseVideo
{
    [_player pause];
    
    [self.playbackControls _setPlayButtonSelect:NO];
    if (self.playerState == SelVideoPlayerStatePlaying) {
        self.playerState = SelVideoPlayerStatePause;
    }
    self.needSetRate = YES;
}

/** 重新播放 */
- (void)_replayVideo
{
    self.playDidEnd = NO;
    [_player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    DRLog(@"重新播放调用播放");
    [self _playVideo];
}

- (void)setPlayDidEnd:(BOOL)playDidEnd{
    _playDidEnd = playDidEnd;
    self.playbackControls.playDidEnd = playDidEnd;
    if (self.playDidEndBlock) {
        self.playDidEndBlock(_playDidEnd);
    }
}

/** 监听播放器事件 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [_playbackControls _setPlayerProgress:timeInterval / totalDuration];
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        // 当无缓冲视频数据时
        if (self.playerItem.playbackBufferEmpty) {
            self.playerState = SelVideoPlayerStateBuffering;
            [self bufferingSomeSecond];
        }
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        // 当视频缓冲好时
        if (self.playerItem.playbackLikelyToKeepUp && self.playerState == SelVideoPlayerStateBuffering){
            self.playerState = SelVideoPlayerStatePlaying;
        }
    }
    else if ([keyPath isEqualToString:@"status"])
    {
        if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
            [self refreshUI];
            [self.layer insertSublayer:_playerLayer atIndex:0];
            self.playerState = SelVideoPlayerStatePlaying;
         
            if (self.isAutoFull) {
                [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeRight];
            }
            DRLog(@"是否需要跳%d",self.isSetDefaultPlaytime);
            if (self.isSetDefaultPlaytime) {
                self.isSetDefaultPlaytime = NO;
                [self seekToTime:CMTimeMake(self.playerConfiguration.defalutPlayTime, 1) completionHandler:nil];
                
                self.playbackControls.lastPlayLocationLabel.hidden = NO;
                
                CGFloat width = GET_STRWIDTH(self.playbackControls.lastPlayLocationLabel.text, 11, 16)+24;
                
                self.playbackControls.lastPlayLocationLabel.frame = CGRectMake(0, self.playbackControls.frame.size.height-35-30, width, 32);
                [self.playbackControls.lastPlayLocationLabel setCornerOnRight:16];
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLocation) object:nil];
                [self performSelector:@selector(hideLocation) withObject:nil afterDelay:2];
                
            }
            
        }
        else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            self.playerState = SelVideoPlayerStateFailed;
        }
    }
}

/**
 *  计算缓冲进度
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    self.playerState = SelVideoPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self _pauseVideo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DRLog(@"缓冲差调用播放");
        [self _playVideo];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp)
        {
            [self bufferingSomeSecond];
        }
        
    });
}


//来了语音通话
- (void)pausePlay{
    [self _pauseVideo];
}

/** 应用进入后台 */
- (void)appDidEnterBackground:(NSNotification *)notify
{
    //判断当前是否为画中画
    //关闭画中画
  
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appdel.pipVC.isPictureInPictureActive) {//禁止自动开启画中画
        appdel.pipVC = nil;
        [self _pauseVideo];
    }
}

/** 应用进入前台 */
- (void)appDidEnterPlayground:(NSNotification *)notify
{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appdel.pipVC) {
        //1.判断是否支持画中画功能
        if ([AVPictureInPictureController isPictureInPictureSupported]) {
            appdel.pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.playerLayer];
            appdel.pipVC.delegate = self;
        }
    }
    DRLog(@"进入前台调用播放");
    [self _playVideo];
    [self.playbackControls _playerShowOrHidePlaybackControls];
}

/** 视频播放结束事件监听 */
- (void)videoDidPlayToEnd:(NSNotification *)notify
{
    self.playDidEnd = YES;
    if (_playerConfiguration.repeatPlay) {
        [self _replayVideo];
    }else
    {
        [self _pauseVideo];
    }
}

- (void)setPlayerSource{
    
    self.playerItem = [AVPlayerItem playerItemWithURL:_playerConfiguration.sourceUrl];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self _setVideoGravity:_playerConfiguration.videoGravity];
    self.backgroundColor = [UIColor blackColor];
}

/** 创建播放器 以及控制面板*/
- (void)_setupPlayer
{
    [self startServer];
    // *后台播放代码
    AVAudioSession*session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    [self.player cancelPendingPrerolls];
    self.player = nil;
    self.playerItem = nil;
    
    NSURL * proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:_playerConfiguration.sourceUrl];
    AVURLAsset *urlAeest = [AVURLAsset assetWithURL:proxyURL];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:urlAeest];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self _setVideoGravity:_playerConfiguration.videoGravity];
    self.backgroundColor = [UIColor blackColor];
    
    // 增加下面这行可以解决iOS10兼容性问题了
    if ([self.player respondsToSelector:@selector(automaticallyWaitsToMinimizeStalling)]) {
        if (@available(iOS 10.0, *)) {
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
    
    [self configureVolume];
    
    /** 创建进度监听器 */
    [self createTimer];
    
    if (_playerConfiguration.shouldAutoPlay) {
        self.needSetRate = YES;
        DRLog(@"创建资源调用播放");
        [self _playVideo];
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.pipVC) {
        appdel.pipVC = nil;
    }
    if (!appdel.pipVC) {
        //1.判断是否支持画中画功能
        if ([AVPictureInPictureController isPictureInPictureSupported]) {
            appdel.pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.playerLayer];
            appdel.pipVC.delegate = self;
        }
    }
}

//开启本地服务器配置
-(void)startServer{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error;
        [KTVHTTPCache proxyStart:&error];
        if (error) {
            DRLog(@"开启服务失败");
        }else{
            DRLog(@"开启服务成功");
            
            long GB = 5;
            [KTVHTTPCache cacheSetMaxCacheLength:1024 * 1024 * 1024 * GB];
        }
    });
    

}


// 即将开启画中画
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    DRLog(@"即将开启画中画");
}
// 已经开启画中画
- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    DRLog(@"已经开启画中画");
}
// 开启画中画失败
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error{
    DRLog(@"开启画中画失败");
}
// 即将关闭画中画
- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    DRLog(@"即将关闭画中画");
}
// 已经关闭画中画
- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController{
    DRLog(@"已经关闭画中画");
    [self _playVideo];
}
// 关闭画中画且恢复播放界面
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    DRLog(@"关闭画中画且恢复播放界面");
}

/** 添加播放器控制面板 */
- (void)_setupPlayControls
{

    self.playbackControls.rate = self.playerConfiguration.rate;
    [self addSubview:self.playbackControls];
 
    if(self.isSetDefaultPlaytime){
        self.playbackControls.lastPlayLocationLabel.text = [NSString stringWithFormat:@"已为你定位至%@",[self getMMSSFromSS:self.playerConfiguration.defalutPlayTime]];
    }
    
    
    [self refreshUI];
    
    if (self.isPay) {
        self.playbackControls.scrollLabel.hidden = NO;
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        //放在主线程中
        AFNetworkReachabilityStatus status = [[HWNetworkReachabilityManager shareManager] networkReachabilityStatus];

        // 当前是什么网络
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {//移动网络播放给提示
          
            [self getSize];
        }
    });
}

- (void)hidewanknow{
    self.playbackControls.wanPlayLabel.hidden = YES;
}

- (void)getSize{
    if (self.isPlayLocalVideo) {
        return;
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.playerConfiguration.sourceUrl options:nil];// url：网络视频的连接
    NSArray *arr = [asset tracksWithMediaType:AVMediaTypeVideo];// 项目中是明确媒体类型为视频，其他没试过

    for (AVAssetTrack *track in arr) {
        if([track.mediaType isEqualToString:AVMediaTypeVideo])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playbackControls.wanPlayLabel.hidden = NO;
                NSString *Str1 = @"正在使用流量播放该视频 大小约";
                NSString *Str2 = [HWToolBox stringFromByteCount:track.totalSampleDataLength];
                NSString *allStr = [NSString stringWithFormat:@"%@ %@",Str1,Str2];
                self.playbackControls.wanPlayLabel.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#1FC7FF"] setLengthString:Str2 beginSize:allStr.length-Str2.length];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidewanknow) object:nil];
                [self performSelector:@selector(hidewanknow) withObject:nil afterDelay:3];
            });
       
        }
        
    }
}

-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
 
    NSInteger seconds = totalTime;
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@:%@:%@",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"00",str_second.intValue?str_second:@"00"];
    }else{
        return [NSString stringWithFormat:@"%@:%@",str_minute.intValue?str_minute:@"00",str_second.intValue?str_second:@"00"];
    }
}


/** 创建进度监听器 */
- (void)createTimer {
    __weak typeof(self) weakSelf = self;

    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.playbackControls _setPlaybackControlsWithPlayTime:currentTime totalTime:totalTime sliderValue:value];
            if (weakSelf.currentPlayTimeBlock) {
                weakSelf.currentPlayTimeBlock(currentTime);
            }
            
            if (weakSelf.needSetRate && weakSelf.playerState == SelVideoPlayerStatePlaying) {
                weakSelf.needSetRate = NO;
                
                [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(afterSetRate) object:nil];
                [weakSelf performSelector:@selector(afterSetRate) withObject:nil afterDelay:2];
            }
            
            if (weakSelf.hasShowActivity) {
                weakSelf.hasShowActivity = NO;
                [weakSelf.playbackControls  _activityIndicatorViewShow:NO];
            }
        }
    }];
}

- (void)afterSetRate{
    [self playrateset];
}

/**
 *  从xx秒开始播放视频跳转
 *
 
 */
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler {
    [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}


//演示隐藏当前播放位置
- (void)hideLocation{
    self.playbackControls.lastPlayLocationLabel.hidden = YES;
}

/**
 配置playerLayer拉伸方式
 @param videoGravity 拉伸方式
 */
- (void)_setVideoGravity:(SelVideoGravity)videoGravity
{
    NSString *fillMode = AVLayerVideoGravityResize;
    switch (videoGravity) {
        case SelVideoGravityResize:
            fillMode = AVLayerVideoGravityResize;
            break;
        case SelVideoGravityResizeAspect:
            fillMode = AVLayerVideoGravityResizeAspect;
            break;
        case SelVideoGravityResizeAspectFill:
            fillMode = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
    _playerLayer.videoGravity = fillMode;
}


/**
 @param playerState 播放器的播放状态
 */
- (void)setPlayerState:(SelVideoPlayerState)playerState
{
    _playerState = playerState;
    switch (_playerState) {
        case SelVideoPlayerStateBuffering:
        {
            [_playbackControls _activityIndicatorViewShow:YES];
        }
            break;
        case SelVideoPlayerStatePlaying:
        {
            if (!self.hasShowActivity) {//这个为yes，代表是第一次加载，第一次加载的时候需要时间在走动才消失指示器
                DRLog(@"播放中1");
                [_playbackControls _activityIndicatorViewShow:NO];
            }
 
        }
            break;
        case SelVideoPlayerStateFailed:
        {
            DRLog(@"播放失败");
            [_playbackControls _activityIndicatorViewShow:NO];
            [_playbackControls _retryButtonShow:YES];
        }
            break;
        default:
            break;
    }
}

/** 改变全屏切换按钮状态 */
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    _playbackControls.isFullScreen = isFullScreen;
    if (isFullScreen) {
        DRLog(@"全屏");
        //隐藏=YES,显示=NO; Animation:动画效果
    }else{
        DRLog(@"非全屏");
        //隐藏=YES,显示=NO; Animation:动画效果
    }
    if (self.fullBlock) {
        self.fullBlock(isFullScreen);
    }
}

/** 根据playerItem，来添加移除观察者 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) {return;}
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}


//耳机相应的事件
- (void)routeChange:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger roteChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (roteChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            //插入耳机
            DRLog(@"插入耳机");
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            //拔出耳机
            DRLog(@"拔出耳机");
            [self _pauseVideo];
            [self.playbackControls _playerShowOrHidePlaybackControls];
            break;
 
    }
    
}


/** 播放器控制面板 */
- (SelPlaybackControls *)playbackControls
{
    if (!_playbackControls) {
        _playbackControls = [[SelPlaybackControls alloc]init];
        _playbackControls.delegate = self;
        _playbackControls.screen = self.screen;
        _playbackControls.isPay = self.isPay;
        _playbackControls.isPlayLocalVideo = self.isPlayLocalVideo;
        _playbackControls.hideInterval = _playerConfiguration.hideControlsInterval;
        _playbackControls.statusBarHideState = _playerConfiguration.statusBarHideState;
    }
    return _playbackControls;
}


- (void)refreshUI{
    self.playerLayer.frame = self.bounds;
    self.playbackControls.frame = self.bounds;
    [self.playbackControls makeConstraints];
}

/** 释放播放器 */
- (void)_deallocPlayer
{
    [self _pauseVideo];
    
    [self.playerLayer removeFromSuperlayer];
    [self removeFromSuperview];
}

/** 释放Self */
- (void)dealloc
{
    self.playerItem = nil;
    [self.playbackControls _playerCancelAutoHidePlaybackControls];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
  
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    
    self.playerLayer = nil;
    self.player = nil;
}

- (void)deallocAll{
    
    [self.fullView removeFromSuperview];
    self.fullView = nil;
    self.playerItem = nil;
    [self.playbackControls _playerCancelAutoHidePlaybackControls];
  
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    self.playerLayer = nil;
    self.player = nil;
}

#pragma mark 播放器控制面板代理

//倍速播放
- (void)palyWithRate:(CGFloat)rate{
    self.rate = self.playbackControls.rate;
    if (self.playerState == SelVideoPlayerStatePlaying) {
        [self playrateset];
    }
}

/**
 播放按钮点击事件
 @param selected 播放按钮选中状态
 */
- (void)playButtonAction:(BOOL)selected
{
    if (selected){
        [self _pauseVideo];
    }else{
        DRLog(@"点击播放调用播放");
        [self _playVideo];
    }
}

//点击下载
- (void)downloadAction{

    if (self.downVideoBlock) {
        self.downVideoBlock(YES);
    }
}

/** 全屏切换按钮点击事件 */
- (void)fullScreenButtonAction
{
    if (!_isFullScreen) {
        [self _videoZoomInWithDirection:UIInterfaceOrientationLandscapeRight];
    }else
    {
        [self _videoZoomOut];
    }
}

/** 控制面板单击事件 */
- (void)tapGesture
{
    [_playbackControls _playerShowOrHidePlaybackControls];
}

/** 控制面板双击事件 */
- (void)doubleTapGesture
{
    if (_playerConfiguration.supportedDoubleTap) {
        if (self.playerState == SelVideoPlayerStatePlaying) {
            [self _pauseVideo];
        }
        else if (self.playerState == SelVideoPlayerStatePause)
        {
            DRLog(@"点击控制面板调用播放");
            [self _playVideo];
        }
    }
}

/** 重新加载视频 */
- (void)retryButtonAction
{
    [_playbackControls _retryButtonShow:NO];
    [_playbackControls _activityIndicatorViewShow:YES];
    [self _setupPlayer];
    DRLog(@"重新加载视频调用播放");
    [self _playVideo];
}

//开始拖动视图
- (void)panHorizontalBeginMoved{
    CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    if (totalTime <= 0) {//没有获取的视频总时长则不执行
        return;
    }
    
    self.sumTime = (NSInteger)CMTimeGetSeconds([_playerItem currentTime]);
    [self videoSliderTouchBegan:self.playbackControls.videoSlider];
}

//拖动中
- (void)panHorizontalMoving:(CGFloat)value{
    CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    if (totalTime <= 0) {//没有获取的视频总时长则不执行
        return;
    }
    self.sumTime += value/200;
    // 需要限定sumTime的范围
    CGFloat totalMovieDuration = totalTime;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}//拖动时长大于视频时长，则拖动时长等于视频时长
    if (self.sumTime < 0) { self.sumTime = 0; }//拖动时长小于0则拖动时长等于0
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    CGFloat draggedValue = (CGFloat)self.sumTime/(CGFloat)totalMovieDuration;
    self.playbackControls.videoSlider.value = draggedValue;
    [self videoSliderValueChanged:self.playbackControls.videoSlider];
}

//拖动结束
- (void)panHorizontalEndMoved{
    CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    if (totalTime <= 0) {//没有获取的视频总时长则不执行
        return;
    }
    self.sumTime = 0;
    [self videoSliderTouchEnded:self.playbackControls.videoSlider];
}

#pragma mark 滑杆拖动代理
/** 开始拖动 */
-(void)videoSliderTouchBegan:(SelVideoSlider *)slider{
    self.playbackControls.pauseIfForDrag = YES;
    [self _pauseVideo];
    [_playbackControls _playerCancelAutoHidePlaybackControls];
    self.playbackControls.fastLabel.hidden = NO;
    self.playbackControls.fastLabel.center = self.playbackControls.center;
    self.playbackControls.fastLabel.text = [NSString stringWithFormat:@"%@/%@",self.playbackControls.playTimeLabel.text,self.playbackControls.totalTimeLabel.text];
}
/** 结束拖动 */
-(void)videoSliderTouchEnded:(SelVideoSlider *)slider{

    if (slider.value != 1) {
        self.playDidEnd = NO;
    }
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }else{
        //继续播放
        DRLog(@"拖动结束调用播放");
        [self _playVideo];
    }
    [_playbackControls _playerAutoHidePlaybackControls];
    self.playbackControls.fastLabel.hidden = YES;
}

/** 拖拽中 */
-(void)videoSliderValueChanged:(SelVideoSlider *)slider{
    
    CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    CGFloat dragedSeconds = totalTime * slider.value;
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [_player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    NSInteger currentTime = (NSInteger)CMTimeGetSeconds(dragedCMTime);
    [_playbackControls _setPlaybackControlsWithPlayTime:currentTime totalTime:totalTime sliderValue:slider.value];
    
    self.playbackControls.fastLabel.text = [NSString stringWithFormat:@"%@/%@",self.playbackControls.playTimeLabel.text,self.playbackControls.totalTimeLabel.text];
}

//非全屏时候点击返回按钮
- (void)backButtonAction{
    if (self.backPopBlock) {
        self.backPopBlock(YES);
    }
}

/**
 *  改变音量
 */
- (void)volumeValueChange:(CGFloat)value{
    self.volumeViewSlider.value -= value / 10000;
    self.playbackControls.volumeProress.progress.progress -= value / 10000;
    
}

#pragma mark - 系统音量相关
/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];

    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    //若要关掉volumeView，需将volumeView添加至当前视图，如不需要volumeView，可以将它设置到视图外，隐藏掉它：
    [volumeView setFrame:CGRectMake(-1000, -100, 100, 100)];
    [self addSubview:volumeView];
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }

}


- (XLAlertView *)alerView{
    if (!_alerView) {
        _alerView = [[XLAlertView alloc] initWithTitle:@"当前视频禁止录屏哦，录屏过程中视频将暂停播放" message:nil cancleBtn:@"知道了"];
    }
    return _alerView;
}
@end
