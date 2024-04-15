//
//  SXFullPlayCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXFullPlayInfoView.h"
#import "SXVideosComClickView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXFullPlayCell : BaseCell

@property (nonatomic, strong) SXFullPlayInfoView *infoView;
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) UIButton *fullButton;
@property (nonatomic,copy) void(^fullBlock)(BOOL show);
@property (nonatomic,copy) void(^showComBlock)(BOOL show);
@property (nonatomic,copy) void(^openMoreBlock)(BOOL open);
@property (nonatomic,copy) void(^fatherBlock)(CGRect bounds);

@property (nonatomic, strong) SXVideosComClickView *clickView;
@end

NS_ASSUME_NONNULL_END
