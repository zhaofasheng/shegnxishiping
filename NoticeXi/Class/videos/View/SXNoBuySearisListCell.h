//
//  SXNoBuySearisListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXSearisVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXNoBuySearisListCell : BaseCell
@property (nonatomic, strong) SXSearisVideoListModel *videoModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *comimageV;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UILabel *totalTimeL;
@property (nonatomic, strong) UILabel *statusL;
@end

NS_ASSUME_NONNULL_END
