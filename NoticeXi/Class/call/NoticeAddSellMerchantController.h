//
//  NoticeAddSellMerchantController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAddSellMerchantController : NoticeBaseCellController
@property (nonatomic, strong) NoticeMyShopModel *goodsModel;
@property (nonatomic, strong) NSMutableArray *sellGoodsArr;
@property (nonatomic, copy) void(^refreshGoodsBlock)(NSMutableArray *goodsArr);
@property (nonatomic, copy) void(^changePriceBlock)(NSString *price);
@property (nonatomic, copy) void(^deleteGoodMBlock)(NoticeGoodsModel *deleteModel);
@property (nonatomic, assign) BOOL isFromDetail;
@end

NS_ASSUME_NONNULL_END
