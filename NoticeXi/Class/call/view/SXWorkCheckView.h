//
//  SXWorkCheckView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVerifyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXWorkCheckView : UIView
@property (nonatomic, strong) UILabel *statusL1;
@property (nonatomic, strong) UILabel *statusL2;
@property (nonatomic, strong) SXVerifyShopModel *verifyM;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *hangyeL;
@property (nonatomic, strong) UILabel *zhiweiL;

@property (nonatomic, strong) UIImageView *zmImageView;
@property (nonatomic, strong) UIImageView *fmImageView;

@property (nonatomic, strong) UIImageView *zhengshuImageView1;

@property (nonatomic, strong) UIImageView *zhengshuImageView2;

@property (nonatomic, strong) UIImageView *zhengshuImageView3;

@property (nonatomic, strong) UIImageView *zhengshuImageView4;

@property (nonatomic, strong) UIView *fg1View;
@property (nonatomic, strong) UIView *fg2View;
@property (nonatomic, strong) UIView *fg3View;
@property (nonatomic, strong) UIView *fg4View;

@property (nonatomic, strong) UIView *contentView;
@end

NS_ASSUME_NONNULL_END
