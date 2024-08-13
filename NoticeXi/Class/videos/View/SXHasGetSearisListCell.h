//
//  SXHasGetSearisListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXPayForVideoModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXHasGetSearisListCell : BaseCell
@property (nonatomic, strong) CBAutoScrollLabel *titleL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *beforeL;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) SXPayForVideoModel *model;
@property (nonatomic, strong) UIButton *comButton;
@property (nonatomic,copy) void(^deleteScoreBlock)(SXKcComDetailModel *comM);
@property (nonatomic,copy) void(^refreshComBlock)(BOOL isAdd,SXKcComDetailModel *comModel);
@end

NS_ASSUME_NONNULL_END
