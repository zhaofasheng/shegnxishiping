//
//  SXVideoUserCenterView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoUserCenterView : UIView
@property (nonatomic, strong) SXUserModel *userModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *contentL;

@end

NS_ASSUME_NONNULL_END
