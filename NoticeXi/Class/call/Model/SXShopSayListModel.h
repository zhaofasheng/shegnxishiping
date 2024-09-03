//
//  SXShopSayListModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayListModel : NSObject

@property (nonatomic, strong) NSString *dongtaiId;
@property (nonatomic, strong) NSString *shop_id;//店铺id
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_atTime;
@property (nonatomic, strong) NSString *comment_num;//评论数
@property (nonatomic, strong) NSString *is_zan;//是否点赞
@property (nonatomic, strong) NSString *zan_num;//点赞总数
@property (nonatomic, strong) NSDictionary *shop_info;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSAttributedString *attStr;
@property (nonatomic, assign) CGFloat longcontentHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) BOOL hasImageV;

@property (nonatomic, strong) NSArray *img_list;
@property (nonatomic, assign) CGFloat cellHeight;

+ (void)tuijiandinapu:(NSString *)shopId  tuijian:(BOOL)tuijian;
+ (void)deleteDongtai:(NSString *)dontaiId;
@end

NS_ASSUME_NONNULL_END
