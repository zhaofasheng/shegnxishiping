//
//  ZQTCustomSwitch.m
//  ZQTCustomSwitch
//
//  Created by 赵发生 on 16/5/25.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "ZQTCustomSwitch.h"
#define LQXSwitchMaxHeight 80.0f
#define LQXSwitchMinHeight 20.0f

#define LQXSwitchMinWidth 40.0f


@interface ZQTCustomSwitch ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *onContentView;
@property (nonatomic, strong) UIView *offContentView;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, assign) NSInteger ballSize;
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, strong) UIColor *offColor;
@property (nonatomic, strong) UIView *knobView;


- (void)commonInit;

- (CGRect)roundRect:(CGRect)frameOrBounds;

- (void)handleTapTapGestureRecognizerEvent:(UITapGestureRecognizer *)recognizer;

- (void)handlePanGestureRecognizerEvent:(UIPanGestureRecognizer *)recognizer;


@end

@implementation ZQTCustomSwitch

- (id)initWithFrame:(CGRect)frame onColor:(UIColor *)onColor offColor:(UIColor *)offColor font:(UIFont *)font ballSize:(NSInteger )ballSize
{
    self = [super initWithFrame:[self roundRect:frame]];
    if (self) {
        self.ballSize = ballSize;
        self.font = font;
        self.onColor = onColor;
        self.offColor = offColor;
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:[self roundRect:bounds]];
    
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[self roundRect:frame]];
    
    [self setNeedsLayout];
}

- (void)setOnText:(NSString *)onText
{
    if (_onText != onText) {
        _onText = onText;
        
        _onLabel.text = onText;
    }
}

- (void)setOffText:(NSString *)offText
{
    if (_offText != offText) {
        _offText = offText;
        
        _offLabel.text = offText;
    }
}

- (void)setOnTintColor:(UIColor *)onTintColor
{
    if (_onTintColor != onTintColor) {
        _onTintColor = onTintColor;
        
        _onContentView.backgroundColor = onTintColor;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        
        _offContentView.backgroundColor = tintColor;
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    if (_thumbTintColor != thumbTintColor) {
        _thumbTintColor = thumbTintColor;
        
        _knobView.backgroundColor = _thumbTintColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame = self.bounds;
    
    CGFloat r = CGRectGetHeight(self.containerView.bounds) / 2.0;
    
    self.containerView.layer.cornerRadius = r;
    self.containerView.layer.masksToBounds = YES;
    
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.ballSize) / 2.0;
    
    if (!self.isOn) {
        // frame of off status
        self.onContentView.frame = CGRectMake(-1 * CGRectGetWidth(self.containerView.bounds),
                                              0,
                                              CGRectGetWidth(self.containerView.bounds),
                                              CGRectGetHeight(self.containerView.bounds));
        
        self.offContentView.frame = CGRectMake(0,
                                               0,
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetHeight(self.containerView.bounds));
        
        self.knobView.frame = CGRectMake(margin,
                                         margin,
                                         self.ballSize,
                                         self.ballSize);
    } else {
        // frame of on status
        self.onContentView.frame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(self.containerView.bounds),
                                              CGRectGetHeight(self.containerView.bounds));
        
        self.offContentView.frame = CGRectMake(0,
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetHeight(self.containerView.bounds));
        
        self.knobView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - self.ballSize,
                                         margin,
                                         self.ballSize,
                                         self.ballSize);
    }
    
    CGFloat lHeight = 20.0f;
    CGFloat lMargin = r - (sqrtf(powf(r, 2) - powf(lHeight / 2.0, 2))) + margin;
    
    self.onLabel.frame = CGRectMake(lMargin,
                                    r - lHeight / 2.0,
                                    CGRectGetWidth(self.onContentView.bounds) - lMargin - self.ballSize - 2 * margin,
                                    lHeight);
    
    self.offLabel.frame = CGRectMake(self.ballSize + 2 * margin,
                                     r - lHeight / 2.0,
                                     CGRectGetWidth(self.onContentView.bounds) - lMargin - self.ballSize - 2 * margin,
                                     lHeight);
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (_on == on) {
        return;
    }
    
    _on = on;
    
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.ballSize) / 2.0;
    
    if (self.isOn) {
        [UIView animateWithDuration:0.25
                         animations:^{
            self.knobView.backgroundColor = GetColorWithName(VMainThumeWhiteColor);
            self.knobView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - self.ballSize,
                                             margin,
                                             self.ballSize,
                                             self.ballSize);
        }
                         completion:^(BOOL finished){
            self.onContentView.frame = CGRectMake(0,
                                                  0,
                                                  CGRectGetWidth(self.containerView.bounds),
                                                  CGRectGetHeight(self.containerView.bounds));

            self.offContentView.frame = CGRectMake(0,
                                                   CGRectGetWidth(self.containerView.bounds),
                                                   CGRectGetWidth(self.containerView.bounds),
                                                   CGRectGetHeight(self.containerView.bounds));
        }];
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
            self.knobView.backgroundColor = GetColorWithName(VMainThumeColor);
            self.knobView.frame = CGRectMake(margin,
                                             margin,
                                             self.ballSize,
                                             self.ballSize);
        }
                         completion:^(BOOL finished){
            self.onContentView.frame = CGRectMake(-1 * CGRectGetWidth(self.containerView.bounds),
                                                  0,
                                                  CGRectGetWidth(self.containerView.bounds),
                                                  CGRectGetHeight(self.containerView.bounds));
            
            self.offContentView.frame = CGRectMake(0,
                                                   0,
                                                   CGRectGetWidth(self.containerView.bounds),
                                                   CGRectGetHeight(self.containerView.bounds));
        }];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Private API

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    
    _onTintColor = self.onColor;
    _tintColor = self.offColor;
    _thumbTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    _textFont = self.font;
    _textColor = [UIColor whiteColor];
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_containerView];
    
    _onContentView = [[UIView alloc] initWithFrame:self.bounds];
    _onContentView.backgroundColor = _onTintColor;
    [_containerView addSubview:_onContentView];
    
    _offContentView = [[UIView alloc] initWithFrame:self.bounds];
    _offContentView.backgroundColor = _tintColor;
    [_containerView addSubview:_offContentView];
    
    _knobView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ballSize, self.ballSize)];
    _knobView.backgroundColor = GetColorWithName(VMainThumeColor);
    _knobView.layer.cornerRadius = self.ballSize / 2.0;
    [_containerView addSubview:_knobView];
    
    _onLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _onLabel.backgroundColor = [UIColor clearColor];
    _onLabel.textAlignment = NSTextAlignmentCenter;
    _onLabel.textColor = _textColor;
    _onLabel.font = _font;
    _onLabel.text = _onText;
    [_onContentView addSubview:_onLabel];
    
    _offLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _offLabel.backgroundColor = [UIColor clearColor];
    _offLabel.textAlignment = NSTextAlignmentCenter;
    _offLabel.textColor = _textColor;
    _offLabel.font = _font;
    _offLabel.text = _offText;
    [_offContentView addSubview:_offLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapTapGestureRecognizerEvent:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGestureRecognizerEvent:)];
    [self addGestureRecognizer:panGesture];
}

- (CGRect)roundRect:(CGRect)frameOrBounds
{
    CGRect newRect = frameOrBounds;
    
    if (newRect.size.height > LQXSwitchMaxHeight) {
        newRect.size.height = LQXSwitchMaxHeight;
    }
    
    if (newRect.size.height < LQXSwitchMinHeight) {
        newRect.size.height = LQXSwitchMinHeight;
    }
    
    if (newRect.size.width < LQXSwitchMinWidth) {
        newRect.size.width = LQXSwitchMinWidth;
    }
    
    return newRect;
}

- (void)handleTapTapGestureRecognizerEvent:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setOn:!self.isOn animated:NO];
    }
}

- (void)handlePanGestureRecognizerEvent:(UIPanGestureRecognizer *)recognizer
{
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.ballSize) / 2.0;
    CGFloat offset = 6.0f;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if (!self.isOn) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.knobView.frame = CGRectMake(margin,
                                                                      margin,
                                                                      self.ballSize + offset,
                                                                      self.ballSize);
                                 }];
            } else {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.knobView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - (self.ballSize + offset),
                                                                      margin,
                                                                      self.ballSize + offset,
                                                                      self.ballSize);
                                 }];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (!self.isOn) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.knobView.frame = CGRectMake(margin,
                                                                      margin,
                                                                      self.ballSize,
                                                                      self.ballSize);
                                 }];
            } else {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.knobView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - self.ballSize,
                                                                      margin,
                                                                      self.ballSize,
                                                                      self.ballSize);
                                 }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self setOn:!self.isOn animated:YES];
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}



@end
