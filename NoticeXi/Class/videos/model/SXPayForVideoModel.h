//
//  SXPayForVideoModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXSearisVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayForVideoModel : NSObject
@property (nonatomic, strong) NSString *seriesId;//课程id
@property (nonatomic, strong) NSString *series_name;//课程系列名称
@property (nonatomic, strong) NSString *cover_url;//封面
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSMutableArray *searisVideoList;
@property (nonatomic, strong) NSString *episodes;//总课时
@property (nonatomic, strong) NSString *published_episodes;//已发布课时
@property (nonatomic, strong) NSString *created_at;//发布时间
@property (nonatomic, strong) NSArray *videos;//相关视频列表
@property (nonatomic, strong) NSMutableArray *videosArr;
@property (nonatomic, strong) NSString *original_price;//原价
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *simple_cover_url;//小封面
@property (nonatomic, strong) NSString *pay_tip;//支付提示
@property (nonatomic, strong) NSString *is_bought;
@property (nonatomic, assign) BOOL hasBuy;//是否已经购买
@property (nonatomic, strong) NSString *introduce_img_url;//课程详情
@property (nonatomic, strong) NSArray *carousel_images;//轮播图
@property (nonatomic, strong) NSDictionary *update_video;
@property (nonatomic, strong) SXSearisVideoListModel *updateM;
@end

NS_ASSUME_NONNULL_END
