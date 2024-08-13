//
//  SXKcComScoreListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXKcComDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXKcComScoreListCell : BaseCell
@property (nonatomic, strong) SXKcComDetailModel *comModel;
@property (nonatomic, assign) BOOL seeSelf;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *scoreNameL;
@property (nonatomic, strong) UIImageView *scoreImageView;
@property (nonatomic, strong) UILabel *tagLabeL;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic,copy) void(^deleteScoreBlock)(SXKcComDetailModel *comM);

@end

NS_ASSUME_NONNULL_END
