//
//  SXShopSayListController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeCureentShopStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayListController : NoticeBaseCellController
@property (nonatomic, assign) BOOL isSelfSay;
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;//申请状态
@end

NS_ASSUME_NONNULL_END
