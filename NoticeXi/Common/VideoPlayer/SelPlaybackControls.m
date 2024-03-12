//
//  SelBackControl.m
//  SelVideoPlayer
//
//  Created by 赵发生 on 2023/1/26.
//  Copyright © 2023年 赵发生. All rights reserved.
//


#import "SelPlaybackControls.h"
#import <Masonry.h>

static const CGFloat PlaybackControlsAutoHideTimeInterval = 0.3f;
@interface SelPlaybackControls()

/** 控制面板是否显示 */
@property (nonatomic, assign) BOOL isShowing;
/** 加载指示器是否显示 */
@property (nonatomic, assign) BOOL isActivityShowing;
/** 重新加载是否显示 */
@property (nonatomic, assign) BOOL isRetryShowing;

/** 用来保存pan手势快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
@property (nonatomic, strong) CAGradientLayer *gradientLayer1;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation SelPlaybackControls

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


/** 重置控制面板 */
- (void)_resetPlaybackControls
{
    self.bottomControlsBar.alpha = 0;
    self.topControlsBar.alpha = 0;
    self.isShowing = NO;
    [self _activityIndicatorViewShow:YES];
}

/**
 设置视频时间显示以及滑杆状态
 @param playTime 当前播放时间
 @param totalTime 视频总时间
 @param sliderValue 滑杆滑动值
 */
- (void)_setPlaybackControlsWithPlayTime:(NSInteger)playTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue
{
  
    //更新当前播放时间
    self.videoSlider.value = sliderValue;
    self.playTimeLabel.text = [self getMMSSFromSS:playTime];
    //更新总时间
    self.totalTimeLabel.text = [self getMMSSFromSS:totalTime];
    
    [self refreshTimeLtime];
    
}

- (void)refreshTimeLtime{
    if (self.isFullScreen) {
        if (self.screen) {//是否是竖屏
            self.playTimeLabel.frame = CGRectMake(15, 0,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
            self.totalTimeLabel.frame = CGRectMake(_bottomControlsBar.frame.size.width-15-GET_STRWIDTH(self.totalTimeLabel.text, 11, 44), 0,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
            
        }else{
            self.playTimeLabel.frame = CGRectMake(NAVIGATION_BAR_HEIGHT, 0,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
            self.totalTimeLabel.frame = CGRectMake(_bottomControlsBar.frame.size.width-TAB_BAR_HEIGHT-GET_STRWIDTH(self.totalTimeLabel.text, 11, 44), 0,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
        }
    }else{
        self.playTimeLabel.frame = CGRectMake(15, 0,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
        self.totalTimeLabel.frame = CGRectMake(_bottomControlsBar.frame.size.width-50-50-GET_STRWIDTH(self.totalTimeLabel.text, 11, 44), 0,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);

    }
    self.progress.frame = CGRectMake(CGRectGetMaxX(self.playTimeLabel.frame)+8, 20, self.totalTimeLabel.frame.origin.x-CGRectGetMaxX(self.playTimeLabel.frame)-16, 4);
    self.videoSlider.frame = self.progress.frame;

}

- (void)refreshBottomFrame{
    if (self.isPlayLocalVideo || self.isPay) {
        self.downloadBtn.hidden = YES;
    }else{
        self.downloadBtn.hidden = NO;
    }
    
    if (self.isFullScreen) {
        if (self.screen) {//是否是竖屏
            
            self.topControlsBar.frame = CGRectMake(0, 0, self.frame.size.width, NAVIGATION_BAR_HEIGHT);
            self.backBtn.frame = CGRectMake(10,STATUS_BAR_HEIGHT,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
            if (!self.isPlayLocalVideo && !self.isPay) {
                self.downloadBtn.frame = CGRectMake(DR_SCREEN_WIDTH-10-44, STATUS_BAR_HEIGHT, 44, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
            }
            if (self.isPay) {
                _scrollLabel.frame = CGRectMake(0, self.backBtn.frame.origin.y+(self.backBtn.frame.size.height-30)/2, self.frame.size.width, 30);
              
            }
        }else{
            self.topControlsBar.frame = CGRectMake(0, 0, self.frame.size.width,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
            self.backBtn.frame = CGRectMake(NAVIGATION_BAR_HEIGHT-5,0,44,self.topControlsBar.frame.size.height);
            if (!self.isPlayLocalVideo && !self.isPay) {
                self.downloadBtn.frame = CGRectMake(DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-44, 0, 44, self.topControlsBar.frame.size.height);
            }
            if (self.isPay) {
                _scrollLabel.frame = CGRectMake(0, self.backBtn.frame.origin.y+(self.backBtn.frame.size.height-30)/2, _bottomControlsBar.frame.size.width, 30);
             
                if (self.scrollLabel.frame.size.width > 0 && self.scrollLabel.frame.size.height > 0) {
                    [self.scrollLabel rejustlabels];
                }
            }
        }
    }else{
        
        self.topControlsBar.frame = CGRectMake(0, 0, self.frame.size.width, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        self.backBtn.frame = CGRectMake(10,0,44,self.topControlsBar.frame.size.height);
        if (!self.isPlayLocalVideo && !self.isPay) {
            self.downloadBtn.frame = CGRectMake(DR_SCREEN_WIDTH-10-44, 0, 44, self.topControlsBar.frame.size.height);
        }
        self.fullScreenButton.frame = CGRectMake(_bottomControlsBar.frame.size.width-50, 0, 44, 44);
        if (self.isPay) {
            _scrollLabel.frame = CGRectMake(0, self.backBtn.frame.origin.y+(self.backBtn.frame.size.height-30)/2, self.frame.size.width, 30);
            if (self.scrollLabel.frame.size.width > 0 && self.scrollLabel.frame.size.height > 0) {
                [self.scrollLabel rejustlabels];
            }
        }
    }
    
    self.gradientLayer1.frame = self.topControlsBar.bounds;
    self.gradientLayer.frame = self.bottomControlsBar.bounds;
    
    [self refreshTimeLtime];
    
    self.lastPlayLocationLabel.frame = CGRectMake(0, self.frame.size.height-35-30, GET_STRWIDTH(self.lastPlayLocationLabel.text, 12, 32)+24, 32);
    [self.lastPlayLocationLabel setCornerOnRight:16];

    if (!_wanPlayLabel.hidden) {
        CGFloat width = GET_STRWIDTH(@"正在使用流量播放该视频 大小为1000M", 11, 20)+10;
        _wanPlayLabel.frame = CGRectMake((self.frame.size.width-width)/2, CGRectGetMaxY(self.topControlsBar.frame), width, 20);
        [_wanPlayLabel setAllCorner:10];
    }
    
    
    _volumeProress.frame = CGRectMake((self.frame.size.width-175)/2, 32, 175, 32);
}

/** 添加约束 */
- (void)makeConstraints
{

    self.playButton.frame = CGRectMake((self.frame.size.width-64)/2, (self.frame.size.height-64)/2, 64, 64);
    self.retryButton.frame = self.playButton.frame;
    
    if (self.isFullScreen && self.screen) {
        self.bottomControlsBar.frame = CGRectMake(0, self.frame.size.height-44-BOTTOM_HEIGHT, self.frame.size.width, 44+BOTTOM_HEIGHT);
    }else{
        self.bottomControlsBar.frame = CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44);
    }
    
    self.activityIndicatorView.center = self.center;
    [self refreshBottomFrame];
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

/** 显示或隐藏加载指示器 */
- (void)_activityIndicatorViewShow:(BOOL)show
{
    self.isActivityShowing = show;
    if (show) {
//        if (self.playButton.selected) {
//            self.playButton.hidden = YES;
//        }
        self.playButton.hidden = YES;
        [self.activityIndicatorView startAnimating];
    }
    else
    {
        if (self.isShowing && !self.pauseIfForDrag) {
            self.playButton.hidden = NO;
        }
        if (self.pauseIfForDrag) {
            self.pauseIfForDrag = NO;
        }
        [self.activityIndicatorView stopAnimating];
    }
}

/** 显示或隐藏重新加载按钮 */
- (void)_retryButtonShow:(BOOL)show
{
    self.isRetryShowing = show;
    if (show) {
        self.playButton.selected = NO;
        self.playButton.hidden = NO;
        self.retryButton.hidden = NO;
    }else
    {
        self.retryButton.hidden = YES;
    }
}

/** progress显示缓冲进度 */
- (void)_setPlayerProgress:(CGFloat)progress {
    [self.progress setProgress:progress animated:NO];
}

/** 控制播放按钮选择状态 */
- (void)_setPlayButtonSelect:(BOOL)select
{
    self.playButton.selected = select;
    [_playButton setImage:[UIImage imageNamed:self.playDidEnd?@"sxplayfinish_img": @"btn_play"] forState:UIControlStateNormal];
    if (self.playDidEnd) {
        _playButton.hidden = NO;
        [self _playerShowPlaybackControls];
    }
}

/** 显示或隐藏控制面板 */
- (void)_playerShowOrHidePlaybackControls
{
    if (self.isShowing) {
        [self _playerHidePlaybackControls];
    } else {
        [self _playerShowPlaybackControls];
    }
}

/** 显示控制面板 */
- (void)_playerShowPlaybackControls
{
    [self _playerCancelAutoHidePlaybackControls];
    [UIView animateWithDuration:PlaybackControlsAutoHideTimeInterval animations:^{
        [self _showPlaybackControls];
    } completion:^(BOOL finished) {
        self.isShowing = YES;
        [self _playerAutoHidePlaybackControls];
    }];
}

/** 隐藏控制面板 */
- (void)_playerHidePlaybackControls
{
    [self _playerCancelAutoHidePlaybackControls];
    [UIView animateWithDuration:PlaybackControlsAutoHideTimeInterval animations:^{
        [self _hidePlaybackControls];
    } completion:^(BOOL finished) {
        self.isShowing = NO;
    }];
}

/** 显示控制面板 */
- (void)_showPlaybackControls
{
    self.isShowing = YES;
    self.bottomControlsBar.alpha = 1;
    self.topControlsBar.alpha = 1;

    if (!self.isActivityShowing && !self.isRetryShowing) {
        self.playButton.hidden = NO;
    }
 
    [self _showOrHideStatusBar];
}

/** 隐藏控制面板 */
- (void)_hidePlaybackControls
{
    self.isShowing = NO;
    self.topControlsBar.alpha = 0;
    self.bottomControlsBar.alpha = 0;

    if (self.playButton.selected) {
        self.playButton.hidden = YES;
    }
    
    if (self.isFullScreen) {
        [self _showOrHideStatusBar];
    }
}

/** 延时自动隐藏控制面板 */
- (void)_playerAutoHidePlaybackControls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_playerHidePlaybackControls) object:nil];
    [self performSelector:@selector(_playerHidePlaybackControls) withObject:nil afterDelay:_hideInterval];
}

/** 显示或隐藏状态栏 */
- (void)_showOrHideStatusBar
{

}

/** 是否处于全屏状态 */
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    self.fullScreenButton.selected = _isFullScreen;
    self.fullScreenButton.hidden = isFullScreen;
    [self makeConstraints];
}

/** 取消延时隐藏playbackControls */
- (void)_playerCancelAutoHidePlaybackControls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 创建UI */
- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.playButton];
    [self addSubview:self.bottomControlsBar];
    [self addSubview:self.activityIndicatorView];
    [self addSubview:self.retryButton];
    [self addSubview:self.topControlsBar];
    [self addSubview:self.volumeProress];
    
    [_bottomControlsBar addSubview:self.fullScreenButton];
    [_bottomControlsBar addSubview:self.playTimeLabel];
    [_bottomControlsBar addSubview:self.totalTimeLabel];
    [_bottomControlsBar addSubview:self.progress];
    [_bottomControlsBar addSubview:self.videoSlider];
    
    [self makeConstraints];
    [self _resetPlaybackControls];
    [self addGesture];
    
    [self bringSubviewToFront:self.topControlsBar];
}

/** 添加手势 */
- (void)addGesture
{
    //单击手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:singleTapGesture];
    
    //双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    
    //当系统检测不到双击手势时执行再识别单击手势，解决单双击收拾冲突
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    // 添加平移手势，用来控制音量、亮度、快进快退
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    self.panRecognizer.delegate = self;
    [self.panRecognizer setMaximumNumberOfTouches:1];
    [self.panRecognizer setDelaysTouchesBegan:YES];
    [self.panRecognizer setDelaysTouchesEnded:YES];
    [self.panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:self.panRecognizer];
}

#pragma mark - UIPanGestureRecognizer手势方法
/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    // 根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection = PanDirectionHorizontalMoved;
                if ([self.delegate respondsToSelector:@selector(panHorizontalBeginMoved)]) {
                    [self.delegate panHorizontalBeginMoved];
                }
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                    self.volumeProress.isBright = NO;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                    self.volumeProress.isBright = YES;
                }
                self.volumeProress.hidden = NO;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if ([self.delegate respondsToSelector:@selector(panHorizontalMoving:)]) {
                        [self.delegate panHorizontalMoving:veloctyPoint.x];
                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if ([self.delegate respondsToSelector:@selector(panHorizontalEndMoved)]) {
                        [self.delegate panHorizontalEndMoved];
                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    _volumeProress.hidden = YES;
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    if (self.isVolume) {
        //改变音量
        if ([self.delegate respondsToSelector:@selector(volumeValueChange:)]) {
            [self.delegate volumeValueChange:value];
        }
    } else {
        //改变屏幕亮度
        ([UIScreen mainScreen].brightness -= value / 10000);
        self.volumeProress.progress.progress  -= value / 10000;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playDidEnd){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        if (self.isBottomVideo && !self.isFullScreen) {
//            return NO;
//        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}

- (SXDragChangeValueView *)volumeProress{
    if (!_volumeProress) {
        _volumeProress = [[SXDragChangeValueView alloc] initWithFrame:CGRectMake((self.frame.size.width-175)/2, 32, 175, 32)];

        _volumeProress.hidden = YES;
    }
    return _volumeProress;
}


/** 加载指示器 */
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityIndicatorView;
}

/** 底部控制栏 */
- (UIView *)bottomControlsBar
{
    if (!_bottomControlsBar) {
        _bottomControlsBar = [[UIView alloc]init];
        _bottomControlsBar.userInteractionEnabled = YES;
        
        //渐变色
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.0].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 44);
        self.gradientLayer = gradientLayer;
        [_bottomControlsBar.layer addSublayer:self.gradientLayer];
    }
    return _bottomControlsBar;
}

/** 底部控制栏 */
- (UIView *)topControlsBar
{
    if (!_topControlsBar) {
        _topControlsBar = [[UIView alloc]init];
        _topControlsBar.userInteractionEnabled = YES;

        //渐变色
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.0].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.frame = _topControlsBar.bounds;
        
        self.gradientLayer1 = gradientLayer;
        [_topControlsBar.layer addSublayer:self.gradientLayer1];
        
        [_topControlsBar addSubview:self.backBtn];
        [_topControlsBar addSubview:self.downloadBtn];
        self.downloadBtn.hidden = YES;
    }
    return _topControlsBar;
}

/** 播放按钮 */
- (UIButton *)playButton
{
    if (!_playButton){
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

/** 全屏切换按钮 */
- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"ic_turn_screen_white_18x18_"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn = [[UIButton alloc] init];
        [_downloadBtn setImage:UIImageNamed(@"sxdownload_img") forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _downloadBtn;
}


- (void)backAction{
    if (self.isFullScreen) {
        [self fullScreenAction];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(backButtonAction)]) {
            [_delegate backButtonAction];
        }
    }
}

/** 当前播放时间 */
- (UILabel *)playTimeLabel
{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc]init];
        _playTimeLabel.font = [UIFont systemFontOfSize:10];
        _playTimeLabel.text = @"00:00";
        _playTimeLabel.adjustsFontSizeToFitWidth = YES;
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.textColor = [UIColor whiteColor];
    }
    return _playTimeLabel;
}

/** 视频总时间 */
- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:10];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}

/** 加载失败重试按钮 */
- (UIButton *)retryButton
{
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setImage:[UIImage imageNamed:@"Action_reload_player_100x100_"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryAction) forControlEvents:UIControlEventTouchUpInside];
        _retryButton.hidden = YES;
    }
    return _retryButton;
}

/** 播放进度条 */
- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc]init];
        _progress.progressTintColor = [UIColor whiteColor];
        _progress.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    return _progress;
}

- (UILabel *)lastPlayLocationLabel{
    if (!_lastPlayLocationLabel) {
        _lastPlayLocationLabel = [[UILabel  alloc] init];
        _lastPlayLocationLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _lastPlayLocationLabel.textAlignment = NSTextAlignmentCenter;
        _lastPlayLocationLabel.font = ELEVENTEXTFONTSIZE;
        _lastPlayLocationLabel.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
        _lastPlayLocationLabel.hidden = YES;
        [self addSubview:_lastPlayLocationLabel];
    
    }
    return _lastPlayLocationLabel;
}

- (UILabel *)wanPlayLabel{
    if (!_wanPlayLabel) {
        _wanPlayLabel = [[UILabel  alloc] init];
        _wanPlayLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _wanPlayLabel.textAlignment = NSTextAlignmentCenter;
        _wanPlayLabel.font = ELEVENTEXTFONTSIZE;
        _wanPlayLabel.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
        _wanPlayLabel.hidden = YES;
        [self addSubview:_wanPlayLabel];
    
    }
    return _wanPlayLabel;
}


- (UILabel *)fastLabel{
    if (!_fastLabel) {
        _fastLabel = [[UILabel  alloc] init];
        _fastLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _fastLabel.textAlignment = NSTextAlignmentCenter;
        _fastLabel.font = ELEVENTEXTFONTSIZE;
        _fastLabel.layer.cornerRadius = 2;
        _fastLabel.frame = CGRectMake(0, 0, GET_STRWIDTH(@"00:00:00/00:00:00", 11, 20), 20);
        _fastLabel.center = self.center;
        _fastLabel.layer.masksToBounds = YES;
        _fastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _fastLabel.hidden = YES;
        [self addSubview:_fastLabel];
    }
    return _fastLabel;
}

- (SXScrollLabel *)scrollLabel{
    if (!_scrollLabel) {
        _scrollLabel = [[SXScrollLabel  alloc] init];
        _scrollLabel.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
        _scrollLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        __weak typeof(self) weakSelf = self;
        _scrollLabel.text = @"[版权声明]本课程版权归作者所有，仅限学习，严禁任何形式的录制，传播和分享，一经发现，平台将依法保留追究权，情节严重者将承担法律责任";
        _scrollLabel.scrollFinishBlcok = ^(BOOL finish) {
            weakSelf.scrollLabel.hidden = YES;
        };
        
        [self addSubview:_scrollLabel];
        [self bringSubviewToFront:self.topControlsBar];
    }
    return _scrollLabel;
}

/** 滑杆 */
- (SelVideoSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider = [[SelVideoSlider alloc]init];
        
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        _videoSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        //开始拖动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        //拖动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //结束拖动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    }
    return _videoSlider;
}

//点击下载
- (void)downClick{
    if (_delegate && [_delegate respondsToSelector:@selector(downloadAction)]) {
        [_delegate downloadAction];
    }
}

#pragma mark - 滑杆
/** 开始拖动事件 */
- (void)progressSliderTouchBegan:(SelVideoSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderTouchBegan:)]) {
        [_delegate videoSliderTouchBegan:slider];
    }
}
/** 拖动中事件 */
- (void)progressSliderValueChanged:(SelVideoSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderValueChanged:)]) {
        [_delegate videoSliderValueChanged:slider];
    }
}
/** 结束拖动事件 */
- (void)progressSliderTouchEnded:(SelVideoSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(videoSliderTouchEnded:)]) {
        [_delegate videoSliderTouchEnded:slider];
    }
}

/** 播放按钮点击事件 */
- (void)playAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(playButtonAction:)]) {
        [_delegate playButtonAction:button.selected];
    }
}

/** 全屏切换按钮点击事件 */
- (void)fullScreenAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(fullScreenButtonAction)]) {
        [_delegate fullScreenButtonAction];
    }
}

/** 重试按钮点击事件 */
- (void)retryAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(retryButtonAction)]) {
        [_delegate retryButtonAction];
    }
}

/** 控制面板单击事件 */
- (void)tap:(UIGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapGesture)]) {
        [_delegate tapGesture];
    }
}

/** 控制面板双击事件 */
- (void)doubleTap:(UIGestureRecognizer *)gesture
{   
    if (_delegate && [_delegate respondsToSelector:@selector(doubleTapGesture)]) {
        [_delegate doubleTapGesture];
    }
}


@end
