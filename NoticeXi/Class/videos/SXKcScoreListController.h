//
//  SXKcScoreListController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXKcScoreListController : NoticeBaseCellController
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, assign) NSString *type;//1全部 2我的评价 3按照分数筛选
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSMutableArray *labelArr;
@end

NS_ASSUME_NONNULL_END
