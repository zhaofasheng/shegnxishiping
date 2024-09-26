//
//  SXPayKCDetailComController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXPayForVideoModel.h"
#import "JXPagerView.h"
#import "SXBuyToastKcView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayKCDetailComController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic,copy) void(^refreshCommentCountBlock)(NSString *commentCount);
- (void)refreshStatus;
@property (nonatomic,copy) void(^clickVideoIdBlock)(NSString *videoId,NSString *commentId);
@property (nonatomic,copy) void(^buyBlock)(BOOL buy);

@property (nonatomic,copy) void(^showBlock)(BOOL buy);
- (void)deleteCommentWith:(NSString *)commentModel;
@property (nonatomic, strong) SXBuyToastKcView *buyView;
- (void)showBuyView:(NSString *)price;
@end

NS_ASSUME_NONNULL_END
