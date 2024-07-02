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
NS_ASSUME_NONNULL_BEGIN

@interface SXPayKCDetailComController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic,copy) void(^refreshCommentCountBlock)(NSString *commentCount);
- (void)refreshStatus;
@end

NS_ASSUME_NONNULL_END
