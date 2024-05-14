//
//  SXStudyListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXStudyListCell : BaseCell

@property (nonatomic, strong) SXPayForVideoModel *studyModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UIImageView *coverImageView;
@end

NS_ASSUME_NONNULL_END
