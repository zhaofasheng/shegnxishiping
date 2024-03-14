//
//  SXBuyVideoOrderList.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXPayForVideoModel.h"
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
@end

NS_ASSUME_NONNULL_END
