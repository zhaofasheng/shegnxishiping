//
//  SXUserCenterHeader.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/21.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXUserCenterHeader : UIView
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) FSCustomButton *freuView;
@property (nonatomic, strong) UIView *jinbiView;

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *moneyL;
@end

NS_ASSUME_NONNULL_END
