//
//  SXKCcomCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXVideoCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXKCcomCell : BaseCell
@property (nonatomic, assign) BOOL hasBuy;
@property (nonatomic, strong) SXVideoCommentModel *comModel;
@property (nonatomic, strong) SXUserModel *videoUser;//视频作者的信息
@property (nonatomic,copy) void(^clickVideoIdBlock)(NSString *videoId);

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *videView;
@property (nonatomic, strong) UILabel *viedoNameL;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *authorHasReplyL;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UILabel *comNumL;
@property (nonatomic, strong) UIImageView *comImageView;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UILabel *authorL;
@end

NS_ASSUME_NONNULL_END
