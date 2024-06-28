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
@end

NS_ASSUME_NONNULL_END
