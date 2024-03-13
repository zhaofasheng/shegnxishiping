//
//  SXZiGeCheckView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVerifyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXZiGeCheckView : UIView
@property (nonatomic, strong) UILabel *statusL1;
@property (nonatomic, strong) UILabel *statusL2;
@property (nonatomic, strong) SXVerifyShopModel *verifyM;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *zyL;

@property (nonatomic, strong) UIImageView *zmImageView;
@property (nonatomic, strong) UIImageView *fmImageView;
@property (nonatomic, strong) UIImageView *zgImageView;
@end

NS_ASSUME_NONNULL_END
