//
//  SXVideoCmmentFirstCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVideoCommentModel.h"
#import "GZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCmmentFirstCell : UITableViewHeaderFooterView<LCActionSheetDelegate,GZLabelDelegate>
@property (nonatomic, strong) SXVideoCommentModel *commentM;
@property (nonatomic, strong) SXUserModel *videoUser;//视频作者的信息

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) GZLabel *contentL;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *authorHasReplyL;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UILabel *authorL;
@property (nonatomic, strong) UILabel *topL;
@property (nonatomic,copy) void(^replyClickBlock)(SXVideoCommentModel *commentM);
@property (nonatomic,copy) void(^deleteClickBlock)(SXVideoCommentModel *commentM);
@property (nonatomic,copy) void(^topClickBlock)(SXVideoCommentModel *commentM);
@property (nonatomic,copy) void(^linkClickBlock)(NSString *searId);
@end

NS_ASSUME_NONNULL_END
