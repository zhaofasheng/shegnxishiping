//
//  SXBuyVideoOrderList.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXPayForVideoModel.h"
#import "SXKcCardListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBuyVideoOrderList : NSObject
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) NSDictionary *series_info;
@property (nonatomic, strong) NSString *product_type;//产品类型(2课程  3课程礼品卡)
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *pay_time;
@property (nonatomic, strong) NSDictionary *series_card_info;
@property (nonatomic, strong) SXKcCardListModel *cardModel;
@end

NS_ASSUME_NONNULL_END
