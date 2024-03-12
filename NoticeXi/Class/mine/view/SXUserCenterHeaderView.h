//
//  SXUserCenterHeaderView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXUserCenterHeaderView : UIView

@property (nonatomic, strong) NoticeUserInfoModel *userM;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) FSCustomButton *freuView;

@end

NS_ASSUME_NONNULL_END
