//
//  SXBuyVideoTools.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^orderBlock)(SXOrderStatusModel *payModel);// 访问成功block

@interface SXBuyVideoTools : NSObject

//购买课程
+ (void)buyKcseriesId:(NSString *)seriesId isSeriesCard:(NSString *)isSeriesCard product_id:(NSString *)product_id getOrderBlock:(orderBlock _Nullable)orderBlock;

//购买单个视频
+ (void)buyKSinglecvideoId:(NSString *)videoId product_id:(NSString *)product_id getOrderBlock:(orderBlock _Nullable)orderBlock;

//购买剩余课程
+ (void)buyKSyvideoseriesId:(NSString *)seriesId product_id:(NSString *)product_id  money:(NSString *)money getOrderBlock:(orderBlock _Nullable)orderBlock;

@end

NS_ASSUME_NONNULL_END
