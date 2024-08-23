//
//  SXCompilationCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXCompilationCell : BaseCell
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) NSString *currentVideoId;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *backView;
@end

NS_ASSUME_NONNULL_END
