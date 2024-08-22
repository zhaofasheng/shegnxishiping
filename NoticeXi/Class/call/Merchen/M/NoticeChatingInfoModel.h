//
//  NoticeChatingInfoModel.h
//  NoticeXi
//
//  Created by li lei on 2023/4/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatingInfoModel : NSObject
@property (nonatomic, strong) NSString *price;//单价
@property (nonatomic, strong) NSString *secondOrign;//可通话时长初始时长(单位秒)
@property (nonatomic, strong) NSString *second;//可通话时长(单位秒)
@property (nonatomic, strong) NSString *experience_time;//体验版商品免费时间(单位秒)
@property (nonatomic, strong) NSString *seller_img_url;//卖家头像
@property (nonatomic, strong) NSString *user_balance;//用户实时鲸币余额(单位鲸币)
@property (nonatomic, strong) NSString *user_price;//付费语音通话价格(单位鲸币/分钟)
@property (nonatomic, strong) NSString *is_experience;//是否为体验版(1是 0否)
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *goods_duration;//订单时长
@end

NS_ASSUME_NONNULL_END
