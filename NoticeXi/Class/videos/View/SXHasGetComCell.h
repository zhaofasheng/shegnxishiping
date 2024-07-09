//
//  SXHasGetComCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/3.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXVideoCommentBeModel.h"
#import "SXVideoComInputView.h"
#import "GZLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXHasGetComCell : BaseCell<NoticeVideoComentInputDelegate>
@property (nonatomic, strong) SXVideoCommentBeModel *likeComM;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *authorL;
@property (nonatomic, strong) UILabel *videoNameL;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) GZLabel *contentL;
@property (nonatomic, strong) GZLabel *content1L;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) SXVideoComInputView *inputView;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic,copy) void(^goVideoBlock)(SXVideoCommentBeModel *comM);

@end

NS_ASSUME_NONNULL_END
