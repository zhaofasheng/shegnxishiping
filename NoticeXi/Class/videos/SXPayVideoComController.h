//
//  SXPayVideoComController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXPayForVideoModel.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayVideoComController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, assign) BOOL isVideoCom;
@property (nonatomic, strong) SXSearisVideoListModel *currentPlayModel;
@property (nonatomic,copy) void(^refreshCommentCountBlock)(NSString *commentCount);
@property (nonatomic, strong) NSString *type;//1=普通类型列表2=定位类型列表
@property (nonatomic, strong) NSString *commentId;//评论定位类型 必传 评论ID 没有传0
@property (nonatomic, strong) NSString *replyId;//评论定位类型 必传 回复ID 没有传0
@property (nonatomic, strong) SXUserModel *videoUser;//视频作者的信息
- (void)sendComClick;
@end

NS_ASSUME_NONNULL_END
