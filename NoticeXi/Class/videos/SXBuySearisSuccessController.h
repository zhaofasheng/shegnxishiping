//
//  SXBuySearisSuccessController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBuySearisSuccessController : NoticeBaseCellController
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) SXOrderStatusModel *payStatusModel;
@property (nonatomic, assign) BOOL isFromList;
@end

NS_ASSUME_NONNULL_END
