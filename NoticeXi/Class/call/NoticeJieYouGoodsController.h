//
//  NoticeJieYouGoodsController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJieYouGoodsController : UIViewController<NoticeAssestDelegate,JXPagerViewListViewDelegate>
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NSMutableArray *goodssellArr;
@property (nonatomic, copy) void(^refreshGoodsBlock)(NSMutableArray *goodsArr);
@property (nonatomic, copy) void(^buyGoodsBlock)(NoticeGoodsModel *buyGood);
- (void)manageGoods;
@end

NS_ASSUME_NONNULL_END
