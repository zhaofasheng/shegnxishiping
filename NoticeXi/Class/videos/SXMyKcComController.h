//
//  SXMyKcComController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXKcComDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXMyKcComController : NoticeBaseCellController
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) SXKcComDetailModel *comModel;
@property (nonatomic,copy) void(^refreshComBlock)(BOOL isAdd,SXKcComDetailModel *comModel);
@property (nonatomic, assign) BOOL isFromCom;
@property (nonatomic,copy) void(^deleteScoreBlock)(SXKcComDetailModel *comM);
@end

NS_ASSUME_NONNULL_END
