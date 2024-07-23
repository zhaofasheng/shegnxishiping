//
//  SXHasBuyKcHeaderView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXHasBuyKcHeaderView : UIView
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UILabel *orginMoneyL;
@property (nonatomic, strong) UILabel *buyNumL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *contouinBtn;
@property (nonatomic, strong) UILabel *hasBuyTimeL;
@property (nonatomic, strong) UIImageView *buyImg;
@property (nonatomic, strong) UIView *line;
@property (nonatomic,copy) void(^buyTypeBolck)(BOOL isSend);
@end

NS_ASSUME_NONNULL_END
