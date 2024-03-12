//
//  NoticeShopStatusView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopStatusView : UIView
@property (nonatomic, strong) UIImageView *shopIconImageView;
@property (nonatomic, strong) UIImageView *shopDetailImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UIButton *startGetOrderBtn;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIView *stopGetView;
@property (nonatomic, strong) UILabel *stop1L;

@property (nonatomic,copy) void (^openDoorBlock)(BOOL open);
@property (nonatomic,copy) void (^stopStatusBlock)(BOOL status);
@property (nonatomic,copy) void (^roleChangeBlock)(BOOL role);
@property (nonatomic,copy) void (^detailBlock)(BOOL detail);
@end

NS_ASSUME_NONNULL_END
