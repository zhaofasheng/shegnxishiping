//
//  SXWeiXinPayModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/21.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXWeiXinPayModel : NSObject
//微信支付相关
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *ordersn;
@property (nonatomic, strong) NSString *packageName;
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *timestamp;


@property (nonatomic, strong) NSString *pay_status;//1已取消2已付款
@property (nonatomic, strong) NSString *pay_time;//支付时间
@property (nonatomic, strong) NSString *sn;//支付之后返回的订单号
@end

NS_ASSUME_NONNULL_END
