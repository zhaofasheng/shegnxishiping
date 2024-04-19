

#import "ZFPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"

#import "KTVHTTPCache.h"

#define CellPlayerFatherViewTag  200

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface ZFPlayerView () <UIGestureRecognizerDelegate,UIAlertViewDelegate,SXControllerPlayDelegate>

/** 播放属性 */
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVURLAsset             *urlAsset;
/**
 * The resourceLoader for the videoPlayer.
 */
//@property(nonatomic, strong, nullable)JPVideoPlayerResourceLoader *resourceLoader;

@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;

@property (nonatomic, strong) id                     timeObserve;
/** 滑杆 */
@property (nonatomic, strong) UISlider               *volumeViewSlider;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
/** 定义一个实例变量，保存枚举值 */
//@property (nonatomic, assign) PanDirection           panDirection;
/** 播发器的几种状态 */
@property (nonatomic, assign) ZFPlayerState          state;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL                   isLocked;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/** 是否播放本地文件 */
@property (nonatomic, assign) BOOL                   isLocalVideo;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat                sliderLastValue;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                   repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL                   playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;

/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
///** 双击 */
//@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 视频URL的数组 */
@property (nonatomic, strong) NSArray                *videoURLArray;
/** slider预览图 */
@property (nonatomic, strong) UIImage                *thumbImg;



#pragma mark - UITableViewCell PlayerView

/** palyer加到tableView */
@property (nonatomic, strong) UIScrollView           *scrollView;
/** player所在cell的indexPath */
@property (nonatomic, strong) NSIndexPath            *indexPath;
/** ViewController中页面是否消失 */
@property (nonatomic, assign) BOOL                   viewDisappear;
/** 是否在cell上播放video */
@property (nonatomic, assign) BOOL                   isCellVideo;
/** 是否缩小视频在底部 */
@property (nonatomic, assign) BOOL                   isBottomVideo;
/** 是否切换分辨率*/
@property (nonatomic, assign) BOOL                   isChangeResolution;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL                   isDragged;



@property (nonatomic, assign) NSInteger              seekTime;
@property (nonatomic, strong) NSDictionary           *resolutionDic;


@property (nonatomic, strong) UIView *fullView;
@end

static NSString *JPVideoPlayerURLScheme = @"systemCannotRecognitionScheme";
static NSString *JPVideoPlayerURL = @"www.newpan.com";

@implementation ZFPlayerView

#pragma mark - life Cycle

/**
 *  代码初始化调用此方法
 */
- (instancetype)init {
    self = [super init];
    if (self) {
      
        [self initializeThePlayer];
    }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}

/**
 *  初始化player
 */
- (void)initializeThePlayer {
    self.cellPlayerOnCenter = YES;
}

- (void)dealloc {

    self.playerItem = nil;
    self.urlAsset = nil;
    self.scrollView  = nil;
    ZFPlayerShared.isLockScreen = NO;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // 移除time观察者
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
}

/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL {
    self.repeatToPlay = YES;
    [self resetPlayer];
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {

    //来了语音通话
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlay) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)pausePlay{
    [self pause];
    self.controlView.playImageView.hidden = NO;
}

//全屏播放
- (void)fullPlay{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.fullView];
    [self.fullView addSubview:self];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI/2);
    }completion:^(BOOL finished) {
    }];
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);

    self.isFullScreen = YES;
}

- (void)nomerPlay{
    [_fullView removeFromSuperview];
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
    }completion:^(BOOL finished) {
        
    }];

    [self addPlayerToFatherView:self.playerModel.fatherView];

    self.isFullScreen = NO;
}

- (void)noFullplay{
    [self nomerPlay];
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    self.playerLayer.frame = self.bounds;
    
    self.controlView.frame = self.bounds;
    [self.controlView refreshUI:isFullScreen];
}

- (UIView *)fullView{
    if (!_fullView) {
        _fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _fullView.backgroundColor = [UIColor blackColor];
    }
    return _fullView;
}

- (void)removeObserver{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Public Method

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView {
    static ZFPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[ZFPlayerView alloc] init];
    });
    return playerView;
}

- (void)playerControlView:(UIView *)controlView playerModel:(ZFPlayerModel *)playerModel {
    //控制层按钮在这里，快进下载等
    if (!controlView) {
        // 指定默认控制层
        SXPlayVideoFullControllView *defaultControlView = [[SXPlayVideoFullControllView alloc] initWithFrame:self.bounds];
        self.controlView = defaultControlView;
        self.controlView.delegate = self;
    }
    self.isFirstAlloc = playerModel.isFirstAlloc;
    self.playerModel = playerModel;
    
    self.screen = self.playerModel.screen;
}

/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZFPlayerModel *)playerModel {
    [self playerControlView:nil playerModel:playerModel];
}

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo {
    // 设置Player相关参数
    [self configZFPlayer];
}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    // 这里应该添加判断，因为view有可能为空，当view为空时[view addSubview:self]会crash
    if (view) {
        if(self.superview) {
            [self removeFromSuperview];
        } else {
            [self removeFromSuperview];
        }
        [view addSubview:self];
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_offset(UIEdgeInsetsZero);
//        }];
        self.frame = view.bounds;
        self.controlView.frame = self.bounds;
        self.playerLayer.frame = self.bounds;
        [self.controlView refreshUI:NO];
    }
}

/**
 *  重置player
 */
- (void)resetPlayer {
//    [self.urlAsset.resourceLoader setDelegate:nil queue:dispatch_get_main_queue()];
    //    self.resourceLoader = nil;
    
    // 改为为播放完
    self.playDidEnd         = NO;
    self.urlAsset = nil;
    self.playerItem         = nil;
    self.didEnterBackground = NO;

    // 视频跳转秒数置0
    self.seekTime           = 0;
//    self.isAutoPlay         = YES;
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
//    [self pause];
    [self.player pause];
    [self.player cancelPendingPrerolls];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 把player置为nil
    self.imageGenerator = nil;
    self.player         = nil;
    if (self.isChangeResolution) { // 切换分辨率
        self.isChangeResolution = NO;
    }else { // 重置控制层View
    }
    self.controlView   = nil;
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) {
        [self removeFromSuperview];
    }
    // 底部播放video改为NO
    self.isBottomVideo = NO;
    // cell上播放视频 && 不是重播时
    if (self.isCellVideo && !self.repeatToPlay) {
        // vicontroller中页面消失
        self.viewDisappear = YES;
        self.isCellVideo   = NO;
        self.scrollView     = nil;
        self.indexPath     = nil;
    }
}

/** 重新播放 */
- (void)_replayVideo
{
    self.playDidEnd = NO;
    [_player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self autoPlay];
}

#pragma mark SXControllerPlayDelegate
- (void)playOrPause{
    if (self.isPauseByUser) {
        [self play];
        self.controlView.playImageView.hidden = YES;
    }else{
      
        self.controlView.playImageView.hidden = NO;
        [self pause];
    }
}

// 滑块滑动开始
- (void)sliderTouchBegan:(float)value{

    [self autoPause];
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginChangeVlue)]) {
        [self.delegate beginChangeVlue];
    }
}

// 滑块滑动中
- (void)sliderValueChanged:(float)value{
    CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    CGFloat dragedSeconds = totalTime * value;
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [_player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    self.controlView.fastLabel.hidden = NO;
    
    NSString *allStr = [NSString stringWithFormat:@"%@ / %@",[self getMMSSFromSS:dragedSeconds],[self getMMSSFromSS:totalTime]];
    NSString *str1 = [self getMMSSFromSS:dragedSeconds];
    
    self.controlView.fastLabel.attributedText = [DDHAttributedMode setJiaCuString:allStr setSize:20 setColor:[UIColor whiteColor] setLengthString:str1 beginSize:0];
}

// 滑块滑动结束
- (void)sliderTouchEnded:(float)value{
    DRLog(@"滑动结束2");
    if (value != 1) {
        self.playDidEnd = NO;
    }
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }else{
        //继续播放
        [self autoPlay];
    }
    
    self.controlView.fastLabel.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(endChangeVlue)]) {
        [self.delegate endChangeVlue];
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

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZFPlayerModel *)playerModel {
    self.repeatToPlay = YES;
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configZFPlayer];
}

/**
 *  播放
 */
- (void)play {

    if (self.state == ZFPlayerStatePause) { self.state = ZFPlayerStatePlaying; }
    self.isPauseByUser = NO;
    [_player play];
}

/**
 * 暂停
 */
- (void)pause {
    if (self.state == ZFPlayerStatePlaying) {
        self.state = ZFPlayerStatePause;
        
    }
    self.isPauseByUser = YES;
    [_player pause];
}

#pragma mark - Private Method

/**
 *  用于cell上播放player
 *

 *  @param indexPath indexPath
 */
- (void)cellVideoWithScrollView:(UIScrollView *)scrollView
                    AtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果页面没有消失，并且playerItem有值，需要重置player(其实就是点击播放其他视频时候)
    if (!self.viewDisappear && self.playerItem) {
        [self resetPlayer];
    }
    // 在cell上播放视频
    self.isCellVideo      = YES;
    // viewDisappear改为NO
    self.viewDisappear    = NO;
    // 设置tableview
    self.scrollView       = scrollView;
    // 设置indexPath
    self.indexPath        = indexPath;
}

/**
 *  设置Player相关参数
 */
- (void)configZFPlayer {
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        [self configPlayerWithLocal];
    } else {
        [self configPlayerWithWeb];
    }
}

- (void)configPlayerWithLocal {
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    [self playResource];
}


- (NSURL *)handleVideoURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:JPVideoPlayerURL] resolvingAgainstBaseURL:NO];
    components.scheme = JPVideoPlayerURLScheme;
    return [components URL];
}

- (void)configPlayerWithWeb {

    if(!self.playerModel.useDownAndPlay) {
        //如果不需要边下边播
        self.urlAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
        [self playResource];
    } else {
        NSURL * proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:self.videoURL.absoluteString]];
        self.urlAsset = [AVURLAsset assetWithURL:proxyURL];
        [self playResource];
    }
}

//播放资源
- (void)playResource {
    
    //后台播放
   [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
   //静音状态下播放
   [[AVAudioSession sharedInstance] setActive:YES error:nil];

    
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 增加下面这行可以解决iOS10兼容性问题了
    if ([self.player respondsToSelector:@selector(automaticallyWaitsToMinimizeStalling)]) {
        if (@available(iOS 10.0, *)) {
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
    // 添加播放进度计时器
    [self createTimer];

    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ZFPlayerStatePlaying;
    } else {
        self.state = ZFPlayerStateBuffering;
    }
    self.isLocalVideo = NO;
    // 开始播放
    if(self.playerModel.isAutoPlay) {
        [self play];
        self.isPauseByUser = NO;
    }
}

- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            weakSelf.controlView.slider.value = value;
            if([weakSelf.delegate respondsToSelector:@selector(zf_playerCurrentSliderValue:playerModel:)]) {
                [weakSelf.delegate zf_playerCurrentSliderValue:currentTime playerModel:weakSelf.playerModel];
            }
            
            NSString *str1 = [weakSelf getMMSSFromSS:currentTime];
            NSString *allStr = [NSString stringWithFormat:@"%@/%@",str1,[weakSelf getMMSSFromSS:totalTime]];
            weakSelf.controlView.nomerLabel.attributedText = [DDHAttributedMode setJiaCuString:allStr setSize:11 setColor:[UIColor whiteColor] setLengthString:str1 beginSize:0];
            
            if (weakSelf.isFullScreen) {
                weakSelf.controlView.playTimeLabel.text = str1;
                weakSelf.controlView.totalTimeLabel.text = [weakSelf getMMSSFromSS:totalTime];
            }
            
            [weakSelf.controlView.activity stopAnimating];
        }
    }];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object == self.player.currentItem) {
            if ([keyPath isEqualToString:@"status"]) {
                
                if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                    [self setNeedsLayout];
                    [self layoutIfNeeded];
                    // 添加playerLayer到self.layer
                    [self.layer insertSublayer:self.playerLayer atIndex:0];
                    self.state = ZFPlayerStatepPrepare;
                    self.state = ZFPlayerStatePlaying;
                    
    //                // 跳到xx秒播放视频
                    if (self.seekTime) {
                        [self seekToTime:CMTimeMake(self.seekTime, 1) completionHandler:nil];
                    }
                } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                    self.state = ZFPlayerStateFailed;
                }
            } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
                
                // 计算缓冲进度
//                NSTimeInterval timeInterval = [self availableDuration];
//                CMTime duration             = self.playerItem.duration;
//                CGFloat totalDuration       = CMTimeGetSeconds(duration);
                
            } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
                
                // 当缓冲是空的时候
                if (self.playerItem.playbackBufferEmpty) {
                    self.state = ZFPlayerStateBuffering;
                    [self bufferingSomeSecond];
                }
                
            } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
                
                // 当缓冲好的时候
                if (self.playerItem.playbackLikelyToKeepUp && self.state == ZFPlayerStateBuffering){
                    self.state = ZFPlayerStatePlaying;
                    
                }
            }
        }
    });
}

#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    self.state = ZFPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}

#pragma mark - 计算缓冲进度

/**
 *  计算缓冲进度
 *
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

#pragma mark - Action



#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification {

    self.state = ZFPlayerStateStopped;
    if (self.isBottomVideo && !self.isFullScreen) { // 播放完了，如果是在小屏模式 && 在bottom位置，直接关闭播放器
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
    } else {
        if (!self.isDragged) { // 如果不是拖拽中，直接结束播放
            self.playDidEnd = YES;
            if([self.delegate respondsToSelector:@selector(zf_playerFinished:)]) {
                [self.delegate zf_playerFinished:self.playerModel];
            }

        }
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    if (self.state == ZFPlayerStateFailed) {//如果是播放失败状态就不需要执行自动暂停
        return;
    }
    if(self.playerModel.isAutoPauseWhenBackGround) {
        self.didEnterBackground     = YES;
        [self autoPause];
    } else {
        self.playerLayer.player = nil;
    }
 
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    if (self.state == ZFPlayerStateFailed) {//如果是播放失败状态就不需要执行自动播放
        return;
    }
    if(self.playerModel.isAutoPauseWhenBackGround) {
        self.didEnterBackground     = NO;
        [self autoPlay];
    } else {
        self.playerLayer.player = self.player;
    }
}

/*
 * 非手动播放
 */
- (void)autoPlay {
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    ZFPlayerShared.isLockScreen = self.isLocked;
    if (!self.isPauseByUser) {
        self.state         = ZFPlayerStatePlaying;
        self.isPauseByUser = NO;
        [self play];
    }
}

/*
 *非手动暂停
 */
- (void)autoPause {
    ZFPlayerShared.isLockScreen = YES;
    [_player pause];
    self.state                  = ZFPlayerStatePause;
}


/**
 *  从xx秒开始播放视频跳转
 *
 
 */
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler {
    [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}


/**
 *  根据时长求出字符串
 *
 *  @param time 时长
 *
 *  @return 时长字符串
 */
- (NSString *)durationStringWithTime:(int)time {
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ) {
        if ((self.isCellVideo && !self.isFullScreen) || self.playDidEnd || self.isLocked){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isBottomVideo && !self.isFullScreen) {
            return NO;
        }
        if(self.state == ZFPlayerStatepPrepare) {
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Setter



/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
   
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    
    self.isPauseByUser = YES;

    
}

/**
 *  设置播放的状态
 *
 *  @param state ZFPlayerState
 */
- (void)setState:(ZFPlayerState)state {
    _state = state;
    

    switch (_state) {
        case ZFPlayerStateUnKonw:// 未知状态
        {
            
        }
            break;
        case ZFPlayerStatepPrepare:// 准备播放
        {

        }
            break;
        case ZFPlayerStateFailed:// 播放失败
        {
            DRLog(@"播放失败");
        }
            break;
        case ZFPlayerStateBuffering:// 缓冲中
        {
            if (self.isFirstAlloc) {
                self.isFirstAlloc = NO;
                [self.controlView.activity startAnimating];
            }
            
            [self.controlView.slider startAnimating];
        }
            break;
        case ZFPlayerStatePlaying:// 播放中
        {
            
            [self.controlView.slider stopAnimating];
        }
            break;
        case ZFPlayerStateStopped:// 播放结束
        {
            
        }
            break;
        case ZFPlayerStatePause:// 暂停播放
        {
            
        }
            break;
            
        default:
            break;
    }
   
    if([self.delegate respondsToSelector:@selector(zf_playerPlayerStatusChange:)]) {
        [self.delegate zf_playerPlayerStatusChange:state];
    }
}

/**
 *  根据playerItem，来添加移除观察者
 *
 *  @param playerItem playerItem
 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) {return;}
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 *  根据tableview的值来添加、移除观察者

 */
- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView == scrollView) { return; }
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:kZFPlayerViewContentOffset];
    }
    _scrollView = scrollView;
    if (scrollView) { [scrollView addObserver:self forKeyPath:kZFPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil]; }
}

/**
 *  是否有下载功能
 */
- (void)setHasDownload:(BOOL)hasDownload {
    _hasDownload = hasDownload;
}

- (void)setResolutionDic:(NSDictionary *)resolutionDic {
    _resolutionDic = resolutionDic;
    self.videoURLArray = [resolutionDic allValues];
}

//设置控制层
- (void)setControlView:(SXPlayVideoFullControllView *)controlView {
    if (_controlView) { return; }
    _controlView = controlView;
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
}

- (void)setPlayerModel:(ZFPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    if (playerModel.seekTime) { self.seekTime = playerModel.seekTime; }

    // 分辨率
    if (playerModel.resolutionDic) {
        self.resolutionDic = playerModel.resolutionDic;
    }
    
    if (playerModel.scrollView && playerModel.indexPath && playerModel.videoURL) {
        //如果是cell的那种
        NSCAssert(playerModel.fatherViewTag, @"请指定playerViews所在的faterViewTag");
        [self cellVideoWithScrollView:playerModel.scrollView AtIndexPath:playerModel.indexPath];
        if ([self.scrollView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)playerModel.scrollView;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:playerModel.indexPath];
            UIView *fatherView = [cell.contentView viewWithTag:playerModel.fatherViewTag];
            [self addPlayerToFatherView:fatherView];
        } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)playerModel.scrollView;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:playerModel.indexPath];
            UIView *fatherView = [cell.contentView viewWithTag:playerModel.fatherViewTag];
            [self addPlayerToFatherView:fatherView];
        }
    } else {
        //        if(self.playerModel.playerResource == ZFPlayerResourceVideo) {
        //            NSCAssert(playerModel.fatherView, @"请指定playerView的faterView");
        //        }
        [self addPlayerToFatherView:playerModel.fatherView];
    }
    self.videoURL = playerModel.videoURL;
}


- (void)setPlayerPushedOrPresented:(BOOL)playerPushedOrPresented {
    _playerPushedOrPresented = playerPushedOrPresented;
    if (playerPushedOrPresented) {
        [self pause];
    } else {
        [self play];
    }
}
#pragma mark - Getter

- (AVAssetImageGenerator *)imageGenerator {
    if (!_imageGenerator) {
        _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.urlAsset];
    }
    return _imageGenerator;
}



@end
