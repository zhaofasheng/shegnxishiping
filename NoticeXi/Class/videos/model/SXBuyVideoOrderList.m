//
//  SXBuyVideoOrderList.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyVideoOrderList.h"

@implementation SXBuyVideoOrderList

- (void)setSeries_info:(NSDictionary *)series_info{
    _series_info = series_info;
    self.paySearModel = [SXPayForVideoModel mj_objectWithKeyValues:series_info];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"orderId":@"id"};
}

@end
