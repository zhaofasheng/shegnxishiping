//
//  SXPlayRecoderScrollCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/24.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXVideosModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPlayRecoderScrollCell : BaseCell
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleL;
@end

NS_ASSUME_NONNULL_END
