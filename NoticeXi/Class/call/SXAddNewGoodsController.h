//
//  SXAddNewGoodsController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeGoodsModel.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXAddNewGoodsController : NoticeBaseCellController
@property (nonatomic, strong) NoticeMyShopModel *goodsModel;
@property (nonatomic, strong) NoticeGoodsModel *changeGoodModel;
@property (nonatomic, copy)  void(^refreshBlock)(BOOL refresh);
@end

NS_ASSUME_NONNULL_END
