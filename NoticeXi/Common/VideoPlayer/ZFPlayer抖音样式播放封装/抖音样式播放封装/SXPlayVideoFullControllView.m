
#import "SXPlayVideoFullControllView.h"


@interface SXPlayVideoFullControllView()<ZFSliderViewDelegate>



@end

@implementation SXPlayVideoFullControllView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
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
        
        self.slider = [[ZFSliderView alloc] init];

        self.slider.delegate = self;
        self.slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.slider.minimumTrackTintColor = [UIColor whiteColor];
        self.slider.loadingTintColor = [UIColor whiteColor];
        self.slider.thumbSize = CGSizeMake(12 * 1, 12 * 1);
        self.slider.sliderHeight = 1;
        self.slider.isHideSliderBlock = YES;

        [self addSubview:self.slider];
        
        CGFloat height = TAB_BAR_HEIGHT;
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(-height);
            make.height.mas_equalTo(16 * 1);
        }];
        
        self.slider.sliderBtn.hidden = NO;
        [self.slider setThumbImage:[UIImage imageNamed:@"ic_slider_thumb_30x30_"] forState:UIControlStateHighlighted];
        
        CGFloat width = GET_STRWIDTH(@"00:00:00/00:00:00", 11, 20);
        [self.fastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(width);
            make.bottom.equalTo(self.mas_bottom).with.offset(-height-20);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPauseTap)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)refreshUI:(BOOL)isFull{
    if (isFull) {
        self.backBtn.hidden = NO;
        self.backBtn.frame = CGRectMake(NAVIGATION_BAR_HEIGHT-5,0,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    }else{
        _backBtn.hidden = YES;
    }
   self.playImageView.frame = CGRectMake((self.frame.size.width-64)/2, (self.frame.size.height-64)/2, 64, 64);
   
}

- (UILabel *)fastLabel{
    if (!_fastLabel) {
        _fastLabel = [[UILabel  alloc] init];
        _fastLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _fastLabel.textAlignment = NSTextAlignmentCenter;
        _fastLabel.font = ELEVENTEXTFONTSIZE;
        _fastLabel.layer.cornerRadius = 2;
    
        _fastLabel.layer.masksToBounds = YES;
        _fastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _fastLabel.hidden = YES;
        [self addSubview:_fastLabel];
    }
    return _fastLabel;
}

// 滑块滑动开始
- (void)sliderTouchBegan:(float)value{
    DRLog(@"开始滑动%.f",value);
    self.slider.sliderHeight = 4;
    self.slider.sliderBtn.hidden = NO;

    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:value];
    }
}
// 滑块滑动中
- (void)sliderValueChanged:(float)value{
    DRLog(@"滑动%.f",value);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
}
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value{
    DRLog(@"滑动结束%.f",value);
    self.slider.sliderHeight = 1;
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
@end
