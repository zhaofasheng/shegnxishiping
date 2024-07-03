//
//  SXPayVideoListController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXPayForVideoModel.h"
#import "JXPagerView.h"
#import "SXVideoCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayVideoListController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic,copy) void(^buySuccessBlock)(NSString *searisID);
- (void)gotoPlayViewWith:(NSString *)videoId commentId:(NSString *)commentId;
@property (nonatomic,copy) void(^deleteClickBlock)(SXVideoCommentModel *commentM);
- (void)refreshStatus;
@end

NS_ASSUME_NONNULL_END
