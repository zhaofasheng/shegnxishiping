//
//  SXShopSayDetailController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXShopSayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayDetailController : NoticeBaseCellController
@property (nonatomic, assign) BOOL needUpCom;
@property (nonatomic, strong) SXShopSayListModel *model;
@end

NS_ASSUME_NONNULL_END
