//
//  NoticeMyShopModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeGoodsModel.h"
#import "NoticeShopDataIdModel.h"
#import "SXVerifyShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyShopModel : NSObject

@property (nonatomic, strong) NSDictionary *goods;
@property (nonatomic, strong) NoticeGoodsModel *goodsM;

@property (nonatomic, strong) NSString *certification_title;//认证信息
@property (nonatomic, strong) NSString *min_price;//最低商品价格
@property (nonatomic, strong) NSDictionary *shop;
@property (nonatomic, strong) NoticeMyShopModel *myShopM;
@property (nonatomic, strong) NSString *jingbi;//买家鲸币数量，获取别人店铺信息的时候返回
@property (nonatomic, strong) NSString *get_order_time;//接单等待倒计时时间（单位秒）
@property (nonatomic, strong) NSString *order_over_time;//订单倒计时间（单位秒）
@property (nonatomic, strong) NSString *buy_order_num;//买过的订单数量
@property (nonatomic, strong) NSString *comment_num;
@property (nonatomic, strong) NSString *commentNum;
@property (nonatomic, strong) NSString *my_balance;//钱包余额
@property (nonatomic, strong) NSString *introduce_len;
@property (nonatomic, strong) NSString *introduce_url;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *audit_status;
@property (nonatomic, strong) NSString *operate_status;//经营状态经营状态 1下线  2上线 3服务中
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *income;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *is_stop;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSArray *role_list;
@property (nonatomic, strong) NSMutableArray *role_listArr;
@property (nonatomic, strong) NSString *role_img_url;
@property (nonatomic, strong) NSString *shop_avatar_url;

@property (nonatomic, strong) NSMutableArray *goods_list;
@property (nonatomic, strong) NSMutableArray *goods_listArr;

@property (nonatomic, strong) NSDictionary *texts;
@property (nonatomic, strong) NoticeMyShopModel *textModel;//文案模型
@property (nonatomic, strong) NSString *text1;//文字聊天文案
@property (nonatomic, strong) NSString *text1_jinbi;//文字鲸币
@property (nonatomic, strong) NSString *text2;//语音聊天文案
@property (nonatomic, strong) NSString *text2_jinbi;//语音聊天鲸币/分钟

@property (nonatomic, strong) NSArray *label_list;
@property (nonatomic, strong) NSMutableArray *labelArr;

@property (nonatomic, strong) NSString *tale;//我的故事
@property (nonatomic, assign) CGFloat taleHeight;//故事文案高度
@property (nonatomic, strong) NSMutableAttributedString *taleAtstr;
@property (nonatomic, strong) NSArray *shop_wall_url;//照片墙
@property (nonatomic, strong) NSArray *shop_label;//店铺标签
@property (nonatomic, strong) NSMutableArray *photowallArr;//照片墙
@property (nonatomic, strong) NSMutableArray *tagsArr;//标签数组
@property (nonatomic, strong) NSMutableArray *tagsTextArr;//标签数组
@property (nonatomic, strong) NSString *tagString;//所有标签整合在一起的文案

@property (nonatomic, strong) NSString *is_certified;//是否认证通过 1是0否
@property (nonatomic, strong) NSString *is_submit_authentication;//是否提交过认证审核 1是0否
@property (nonatomic, strong) NSDictionary *authentication_info;//认证信息
@property (nonatomic, strong) SXVerifyShopModel *verifyModel;

@property (nonatomic, strong) NSString *start_time;//店铺设置营业开始时间
@property (nonatomic, strong) NSString *end_time;//店铺设置营业结束时间
@property (nonatomic, strong) NSString *is_timing;//1=设置定时 0=没有定时

@property (nonatomic, strong) NSArray *category_list;
@property (nonatomic, strong) NSMutableArray *categoryNameArr;

@end

NS_ASSUME_NONNULL_END
