//
//  SXSureBuySearisView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXSureBuySearisView : UIView
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *reduceL;
@property (nonatomic, strong) UILabel *introL;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *videoNumL;

@end

NS_ASSUME_NONNULL_END
