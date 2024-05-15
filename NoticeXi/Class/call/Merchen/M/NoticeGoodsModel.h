//
//  NoticeGoodsModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeGoodsModel : NSObject
@property (nonatomic, strong) NSString *goodId;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic,strong) NSString  *shop_user_id;//
@property (nonatomic, strong) NSString *match_time;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *goods_img_url;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString  *choice;
@property (nonatomic, strong) NSString *is_selling;
@property (nonatomic, strong) NSString *is_experience;
@property (nonatomic, strong) NSString *type;//1=文字聊天 2 语音聊天
@property (nonatomic, strong) NSString *experience_time;//免费通话时长
@property (nonatomic, strong) NSString *experience_times;//剩余免费通话次数
@property (nonatomic, strong) NSString *category_name;//商品分类名称
@property (nonatomic, strong) NSString *category_id;//商品分类id
@property (nonatomic, strong) NSString *tagString;
@property (nonatomic, assign) CGFloat nameHeight;
@end

NS_ASSUME_NONNULL_END
