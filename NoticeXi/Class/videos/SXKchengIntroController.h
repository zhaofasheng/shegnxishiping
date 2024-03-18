//
//  SXKchengIntroController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "JXPagerView.h"
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXKchengIntroController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@end

NS_ASSUME_NONNULL_END
