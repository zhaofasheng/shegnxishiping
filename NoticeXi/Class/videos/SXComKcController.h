//
//  SXComKcController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXComKcController : NoticeBaseCellController
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic,copy) void(^refreshComBlock)(BOOL isAdd,SXKcComDetailModel *comModel);
@property (nonatomic,copy) void(^deleteScoreBlock)(SXKcComDetailModel *comM);
@property (nonatomic, assign) BOOL isFromCom;
@end

NS_ASSUME_NONNULL_END
