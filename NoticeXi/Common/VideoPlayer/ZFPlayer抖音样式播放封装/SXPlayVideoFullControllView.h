//
//  SXPlayVideoFullControllView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/25.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSliderView.h"
#import "MMMaterialDesignSpinner.h"
@protocol SXControllerPlayDelegate <NSObject>
@optional

- (void)playOrPause;

// 滑块滑动开始
- (void)sliderTouchBegan:(float)value;
// 滑块滑动中
- (void)sliderValueChanged:(float)value;
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value;
// 滑杆点击
- (void)sliderTapped:(float)value;

//点击非全屏播放
- (void)noFullplay;
@end

NS_ASSUME_NONNULL_BEGIN

@interface SXPlayVideoFullControllView : UIView

@property (nonatomic, strong) ZFSliderView *slider;

@property (nonatomic, strong) UIImageView *playImageView;

@property (nonatomic, strong) UILabel *fastLabel;

//非全屏
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, weak) id<SXControllerPlayDelegate>      delegate;

@property (nonatomic, strong) MMMaterialDesignSpinner *activity;

- (void)refreshUI:(BOOL)isFull;
@end

NS_ASSUME_NONNULL_END
