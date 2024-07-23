//
//  SXBuyKcCardHeaderView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBuyKcCardHeaderView : UIView
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;


@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UILabel *orginMoneyL;
@property (nonatomic, strong) UILabel *buyNumL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *backView1;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *backView2;
@property (nonatomic, strong) UILabel *buyExplainL;
@end

NS_ASSUME_NONNULL_END
