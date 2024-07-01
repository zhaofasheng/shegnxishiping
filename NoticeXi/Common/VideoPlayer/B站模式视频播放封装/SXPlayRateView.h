//
//  SXPlayRateView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/1.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPlayRateView : UIView

@property (nonatomic, assign) NSInteger rate;
@property (nonatomic,copy) void(^rateBlock)(NSInteger rate);
@property (nonatomic, strong) NSMutableArray *buttonArr;
- (void)show;
@property (nonatomic, strong) UIView *contentView;
@end

NS_ASSUME_NONNULL_END
