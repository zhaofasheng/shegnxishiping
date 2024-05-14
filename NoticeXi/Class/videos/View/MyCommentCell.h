//
//  MyCommentCell.h
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "BaseCell.h"
#import "GZLabel.h"
#import "SXVideoCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyCommentCell : BaseCell<LCActionSheetDelegate,GZLabelDelegate>
@property (nonatomic, strong) SXVideoCommentModel *commentM;
@property (nonatomic, strong) SXUserModel *videoUser;//视频作者的信息
@property (nonatomic, strong) UILabel *authorL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) GZLabel *contentL;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *authorHasReplyL;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;

@property (nonatomic,copy) void(^replyClickBlock)(SXVideoCommentModel *commentM);
@property (nonatomic,copy) void(^deleteClickBlock)(SXVideoCommentModel *commentM);
@property (nonatomic, strong) UIView *replyToView;
@property (nonatomic, strong) UILabel *replyNameL;
@property (nonatomic,copy) void(^linkClickBlock)(NSString *searId);
@end

NS_ASSUME_NONNULL_END
