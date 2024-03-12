//
//  SPActivityIndicatorView.m
//  SPActivityIndicatorExample
//
//  Created by iDress on 5/23/15.
//  Copyright (c) 2015 iDress. All rights reserved.
//

#import "SPActivityIndicatorView.h"
#import "SPActivityIndicatorRotaingCurveEaseOutAnimation.h"
#import "SPActivityIndicatorLineScaleAnimation.h"

static const CGFloat kSPActivityIndicatorDefaultSize = 40.0f;

@interface SPActivityIndicatorView () {
    CALayer *_animationLayer;
}

@end

@implementation SPActivityIndicatorView

#pragma mark -
#pragma mark Constructors

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tintColor = [UIColor whiteColor];
        _size = kSPActivityIndicatorDefaultSize;
        [self commonInit];
    }
    return self;
}

- (id)initWithType:(SPActivityIndicatorAnimationType)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kSPActivityIndicatorDefaultSize];
}

- (id)initWithType:(SPActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kSPActivityIndicatorDefaultSize];
}

- (id)initWithType:(SPActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _type = type;
        _size = size;
        _tintColor = tintColor;
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = YES;
    self.hidden = YES;
    
    _animationLayer = [[CALayer alloc] init];
    _animationLayer.frame = self.layer.bounds;
    [self.layer addSublayer:_animationLayer];

    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;
    
    id<SPActivityIndicatorAnimationProtocol> animation = [SPActivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor: from:)]) {
        [animation setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_size, _size) tintColor:_tintColor from:self.left];
        _animationLayer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    _animationLayer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(SPActivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        
        CGColorRef tintColorRef = tintColor.CGColor;
        for (CALayer *sublayer in _animationLayer.sublayers) {
            sublayer.backgroundColor = tintColorRef;
            
            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.strokeColor = tintColorRef;
                shapeLayer.fillColor = tintColorRef;
            }
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<SPActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(SPActivityIndicatorAnimationType)type {
    switch (type) {
        case SPActivityIndicatorAnimationTypeLineScale:
            return [[SPActivityIndicatorLineScaleAnimation alloc] init];
        case SPActivityIndicatorAnimationTypeRotaingCurveEaseOut:
            return [[SPActivityIndicatorRotaingCurveEaseOutAnimation alloc] init];
    }
    return nil;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _animationLayer.frame = self.bounds;

    BOOL animating = _animating;

    if (animating)
        [self stopAnimating];

    [self setupAnimation];

    if (animating)
        [self startAnimating];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_size, _size);
}

@end
