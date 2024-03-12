//
//  SXPlayPayVideoDetailListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXSearisVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPlayPayVideoDetailListCell : BaseCell
@property (nonatomic, strong) SXSearisVideoListModel *videoModel;
@property (nonatomic, strong) SXSearisVideoListModel *currentVideo;
@property (nonatomic, strong) UILabel *titleL;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *fgView;
@property (nonatomic, strong) UIView *fgView1;
@property (nonatomic, strong) UILabel *totalTimeL;
@property (nonatomic, strong) UILabel *statusL;
@end

NS_ASSUME_NONNULL_END
