//
//  SXBuySearisSuccessView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBuySearisSuccessView : UIView
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, strong) UILabel *reasonL;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *moneyL;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *reduceL;

@property (nonatomic, strong) UIButton *orderCopyBtn;
@property (nonatomic, strong) UILabel *originmoneyL;

@property (nonatomic, strong) UILabel *orderNoL;
@property (nonatomic, strong) UILabel *payTimeL;

@property (nonatomic, strong) UIView *subBackView;
@property (nonatomic, strong) SXWeiXinPayModel *payStatusModel;
@end

NS_ASSUME_NONNULL_END
