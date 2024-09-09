//
//  NoticeOrderListModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXShopLyStoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOrderListModel : NSObject
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *shop_user_id;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *unit_price;//语音单价
@property (nonatomic, strong) NSString *user_nick_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *complete_time;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *is_comment;
@property (nonatomic, strong) NSString *shop_avatar_url;
@property (nonatomic, strong) NSString *is_fault;//0无举报 1买家过错 2卖家过错
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, assign) BOOL isNoFinish;//失效的订单
@property (nonatomic, strong) NSString *income;
@property (nonatomic, strong) NSString *room_id;//有这个代表是语音通话订单
@property (nonatomic, strong) NSString *voice_duration;//语音通话时长
@property (nonatomic, strong) NSString *goods_img_url;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *is_experience;
@property (nonatomic, strong) NSString *experience_time;
@property (nonatomic, strong) NSString *is_black;//被对方拉黑了不准留言
@property (nonatomic, strong) NSString *is_certified;//1是认证 0未认证

@property (nonatomic, strong) NSString *after_sales_time;//服务保障有效期(大于0表示还在有效期)
@property (nonatomic, strong) NSString *after_sales_status;//售后状态 0未申请售后 1售后处理中 2已完成售后

@property (nonatomic, strong) NSString *unread_comment_num;//未读留言数
@property (nonatomic, strong) NSDictionary *order_comment;
@property (nonatomic, strong) SXShopLyStoryModel *liuyModel;
@end

NS_ASSUME_NONNULL_END
