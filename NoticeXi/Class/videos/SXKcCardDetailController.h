//
//  SXKcCardDetailController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXKcCardListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXKcCardDetailController : NoticeBaseCellController
@property (nonatomic, strong) SXKcCardListModel *cardModel;
@property (nonatomic, assign) BOOL isGet;

@end

NS_ASSUME_NONNULL_END
