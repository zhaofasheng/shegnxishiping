//
//  SXBuyCardSuccessController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBuyCardSuccessController : NoticeBaseCellController
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) SXOrderStatusModel *payStatusModel;
@property (nonatomic,copy) void(^reBuyBlock)(BOOL buy);

@end

NS_ASSUME_NONNULL_END
