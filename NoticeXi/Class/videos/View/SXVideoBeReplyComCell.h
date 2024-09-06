//
//  SXVideoBeReplyComCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXVideoCommentBeModel.h"
#import "SXVideoComInputView.h"
#import "GZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoBeReplyComCell : BaseCell<NoticeVideoComentInputDelegate>
@property (nonatomic, strong) SXVideoCommentBeModel *likeComM;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *authorL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) GZLabel *contentL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UILabel *shopL;
@property (nonatomic, strong) UILabel *beRelyL;
@property (nonatomic, strong) SXVideoComInputView *inputView;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIView *grayView;
@end

NS_ASSUME_NONNULL_END
