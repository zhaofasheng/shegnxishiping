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
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *pay_time;
@property (nonatomic, strong) NSDictionary *series_card_info;
@property (nonatomic, strong) SXKcCardListModel *cardModel;
@property (nonatomic, strong) NSString *video_title;
@property (nonatomic, strong) NSString *product_type;//订单产品类型 2 课程相关  3 课程卡 4 课程视频
@property (nonatomic, strong) NSString *quantity;//数量(product_type=4时此字段采用，0代表购买单节，大于0代表购买剩下集数)
@end

NS_ASSUME_NONNULL_END
