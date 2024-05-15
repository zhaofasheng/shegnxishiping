//
//  NoticeOtherShopCardController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/10.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOtherShopCardController : UIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isUserLookShop;//是否是用户视角看店铺
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, copy) void(^editShopModelBlock)(BOOL edit);
@property (nonatomic, copy) void(^buyGoodsBlock)(NoticeGoodsModel *buyGood);
@property (nonatomic, copy) void(^refreshGoodsBlock)(NSMutableArray *goodsArr);
- (void)stopPlay;
- (void)scrolllToGoods;
@end

NS_ASSUME_NONNULL_END
