//
//  SXPlayChcahVideoController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPlayChcahVideoController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^choiceVideoBlock)(HWDownloadModel *videoModel);
@property (nonatomic, strong) HWDownloadModel *currentPlayModel;
@end

NS_ASSUME_NONNULL_END
