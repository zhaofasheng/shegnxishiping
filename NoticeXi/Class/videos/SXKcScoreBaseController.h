//
//  SXKcScoreBaseController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXKcScoreBaseController : WMPageController
@property (nonatomic, assign) BOOL hasCom;//自己是否评论过
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@end

NS_ASSUME_NONNULL_END
