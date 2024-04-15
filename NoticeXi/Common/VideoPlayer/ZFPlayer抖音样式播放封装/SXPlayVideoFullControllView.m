
#import "SXPlayVideoFullControllView.h"


@interface SXPlayVideoFullControllView()<ZFSliderViewDelegate>

@property (nonatomic, strong) UIView *blackView;

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
    }else{
        self.slider.frame = CGRectMake(15, self.frame.size.height-8, self.frame.size.width-30, 16);
        self.playTimeLabel.hidden = YES;
        self.totalTimeLabel.hidden = YES;
        self.nomerLabel.hidden = NO;
        self.fastLabel.frame = CGRectMake((self.frame.size.width-self.fastLabel.frame.size.width)/2, self.slider.frame.origin.y-20-60, self.fastLabel.frame.size.width, 28);
        _backBtn.hidden = YES;
        
    }

    self.playImageView.frame = CGRectMake((self.frame.size.width-64)/2, (self.frame.size.height-64)/2, 64, 64);
    self.activity.frame = CGRectMake((self.frame.size.width-45)/2, (self.frame.size.height-45)/2, 45, 45);

    self.blackView.frame = self.bounds;
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
@end
