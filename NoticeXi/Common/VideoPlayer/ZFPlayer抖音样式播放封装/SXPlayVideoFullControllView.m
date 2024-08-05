
#import "SXPlayVideoFullControllView.h"
#import "SXDragChangeValueView.h"
#import <MediaPlayer/MPVolumeView.h>
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirectionFull){
    PanDirectionHorizontalMovedfull, // 横向移动
    PanDirectionVerticalMovedfull    // 纵向移动
};


@interface SXPlayVideoFullControllView()<ZFSliderViewDelegate,UIGestureRecognizerDelegate>
/** 用来保存pan手势快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 滑动 */
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) SXDragChangeValueView *volumeProress;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirectionFull panDirection;
/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;
/** 声音滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;
@end

@implementation SXPlayVideoFullControllView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.blackView = [[UIView alloc] initWithFrame:self.bounds];
        self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.blackView];
        self.blackView.hidden = YES;
        
        self.playImageView = [[UIImageView  alloc] init];
        self.playImageView.userInteractionEnabled = YES;
        self.playImageView.hidden = YES;
        self.playImageView.image = UIImageNamed(@"btn_play");
        [self addSubview:self.playImageView];
        
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(@64);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        self.activity.frame = CGRectMake((DR_SCREEN_WIDTH-45)/2, (DR_SCREEN_HEIGHT-45)/2, 45, 45);
        [self addSubview:self.activity];
        
        self.slider = [[ZFSliderView alloc] initWithFrame:CGRectMake(15, DR_SCREEN_HEIGHT-8, DR_SCREEN_WIDTH-30, 16)];
        self.slider.delegate = self;
        self.slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.slider.minimumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.slider.loadingTintColor = [UIColor whiteColor];
        self.slider.thumbSize = CGSizeMake(12 * 1, 12 * 1);
        self.slider.sliderHeight = 1;
        self.slider.isHideSliderBlock = YES;
        [self addSubview:self.slider];
        
        
        self.slider.sliderBtn.hidden = NO;
        [self.slider setThumbImage:[UIImage imageNamed:@"ic_slider_thumb_30x30_"] forState:UIControlStateHighlighted];
        
        CGFloat width = GET_STRWIDTH(@"00:00:00 / 00:00:00", 20, 28);
  
        self.fastLabel.frame = CGRectMake((DR_SCREEN_WIDTH-width)/2, self.slider.frame.origin.y-20-60, width, 28);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPauseTap)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        // 添加平移手势，用来控制音量、亮度、快进快退
        self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        self.panRecognizer.delegate = self;
        [self.panRecognizer setMaximumNumberOfTouches:1];
        [self.panRecognizer setDelaysTouchesBegan:YES];
        [self.panRecognizer setDelaysTouchesEnded:YES];
        [self.panRecognizer setCancelsTouchesInView:YES];
    }
    return self;
}

- (void)refreshUI:(BOOL)isFull{
    if (isFull) {
        self.nomerLabel.hidden = YES;
        self.backBtn.hidden = NO;
        self.backBtn.frame = CGRectMake(NAVIGATION_BAR_HEIGHT-5,0,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
     
        self.playTimeLabel.hidden = NO;
        self.totalTimeLabel.hidden = NO;
        self.playTimeLabel.frame = CGRectMake(NAVIGATION_BAR_HEIGHT, self.frame.size.height-44,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
        self.totalTimeLabel.frame = CGRectMake(self.frame.size.width-TAB_BAR_HEIGHT-GET_STRWIDTH(self.totalTimeLabel.text, 11, 44), self.frame.size.height-44,GET_STRWIDTH(self.playTimeLabel.text, 11, 44), 44);
        self.slider.frame = CGRectMake(CGRectGetMaxX(self.playTimeLabel.frame)+8, self.playTimeLabel.frame.origin.y+14, self.totalTimeLabel.frame.origin.x-CGRectGetMaxX(self.playTimeLabel.frame)-16, 16);
        self.fastLabel.frame = CGRectMake((self.frame.size.width-self.fastLabel.frame.size.width)/2, self.slider.frame.origin.y-30, self.fastLabel.frame.size.width, 28);
        
        [self configureVolume];
        [self addGestureRecognizer:self.panRecognizer];
    }else{
        self.slider.frame = CGRectMake(15, self.frame.size.height-16, self.frame.size.width-30, 16);
        self.playTimeLabel.hidden = YES;
        self.totalTimeLabel.hidden = YES;
        self.nomerLabel.hidden = NO;
        self.fastLabel.frame = CGRectMake((self.frame.size.width-self.fastLabel.frame.size.width)/2, self.slider.frame.origin.y-20-60, self.fastLabel.frame.size.width, 28);
        _backBtn.hidden = YES;
        [self removeGestureRecognizer:self.panRecognizer];
        _volumeProress.hidden = YES;
    }

    self.playImageView.frame = CGRectMake((self.frame.size.width-64)/2, (self.frame.size.height-64)/2, 64, 64);
    self.activity.frame = CGRectMake((self.frame.size.width-45)/2, (self.frame.size.height-45)/2, 45, 45);

    self.blackView.frame = self.bounds;
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
                self.panDirection = PanDirectionHorizontalMovedfull;
                [self sliderTouchBegan:self.slider.value];
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMovedfull;
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
                case PanDirectionHorizontalMovedfull:{
                    [self panHorizontalMoving:veloctyPoint.x];
                    break;
                }
                case PanDirectionVerticalMovedfull:{
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
                case PanDirectionHorizontalMovedfull:{
                    [self sliderTouchEnded:self.slider.value];
                    break;
                }
                case PanDirectionVerticalMovedfull:{
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

- (void)verticalMoved:(CGFloat)value {
    if (self.isVolume) {
        //改变音量
        [self volumeValueChange:value];
    } else {
        //改变屏幕亮度
        ([UIScreen mainScreen].brightness -= value / 10000);
        self.volumeProress.progress.progress  -= value / 10000;
    }
}

- (void)volumeValueChange:(CGFloat)value{
    self.volumeViewSlider.value -= value / 10000;
    self.volumeProress.progress.progress -= value / 10000;
    
}

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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

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

- (UILabel *)fastLabel{
    if (!_fastLabel) {
        _fastLabel = [[UILabel  alloc] init];
        _fastLabel.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _fastLabel.textAlignment = NSTextAlignmentCenter;
        _fastLabel.font = [UIFont systemFontOfSize:20];
        _fastLabel.hidden = YES;
        [self addSubview:_fastLabel];
    }
    return _fastLabel;
}

- (UILabel *)nomerLabel{
    if (!_nomerLabel) {
        _nomerLabel = [[UILabel  alloc] initWithFrame:CGRectMake(15, self.frame.size.height-8-21, 160, 14)];
        _nomerLabel.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        _nomerLabel.font = ELEVENTEXTFONTSIZE;
        [self addSubview:_nomerLabel];
    }
    return _nomerLabel;
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
        [self addSubview:_playTimeLabel];
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
        [self addSubview:_totalTimeLabel];
    }
    return _totalTimeLabel;
}

// 滑块滑动开始
- (void)sliderTouchBegan:(float)value{
   
    self.blackView.frame = self.bounds;
    [self sendSubviewToBack:self.blackView];
    [UIView animateWithDuration:0.15 animations:^{
        self.slider.sliderHeight = 4;
        self.blackView.hidden = NO;
    }];
    
    self.slider.sliderBtn.hidden = NO;
    self.nomerLabel.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:value];
    }
}
// 滑块滑动中
- (void)sliderValueChanged:(float)value{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
}

//拖动中
- (void)panHorizontalMoving:(CGFloat)value{
    CGFloat totalTime = self.totalTime;
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
    self.slider.value = draggedValue;
    [self sliderValueChanged:draggedValue];
}


// 滑块滑动结束
- (void)sliderTouchEnded:(float)value{
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.slider.sliderHeight = 1;
    }];
    DRLog(@"滑动结束1");
    self.nomerLabel.hidden = NO;
    self.slider.sliderBtn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:value];
    }
    
}

// 滑杆点击
- (void)sliderTapped:(float)value{

}

- (void)playOrPauseTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playOrPause)]) {
        [self.delegate playOrPause];
    }
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

- (void)backAction{
    if ([self.delegate respondsToSelector:@selector(noFullplay)]) {
        [self.delegate noFullplay];
    }
}

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (SXDragChangeValueView *)volumeProress{
    if (!_volumeProress) {
        _volumeProress = [[SXDragChangeValueView alloc] initWithFrame:CGRectMake((self.frame.size.width-175)/2, 32, 175, 32)];
        [self addSubview:_volumeProress];
        _volumeProress.hidden = YES;
    }
    return _volumeProress;
}

@end
