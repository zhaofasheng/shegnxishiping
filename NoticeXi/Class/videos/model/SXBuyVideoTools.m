//
//  SXBuyVideoTools.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyVideoTools.h"

@implementation SXBuyVideoTools

+ (void)buyKcseriesId:(NSString *)seriesId isSeriesCard:(NSString *)isSeriesCard product_id:(NSString *)product_id getOrderBlock:(orderBlock _Nullable)orderBlock{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:seriesId forKey:@"seriesId"];
    [parm setObject:@"3" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:isSeriesCard forKey:@"isSeriesCard"];
    [[NoticeTools getTopViewController] showHUD];
    AppDelegate *appdel1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel1.pushBuySuccess = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            
            SXOrderStatusModel *payModel = [SXOrderStatusModel mj_objectWithKeyValues:dict[@"data"]];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.isBuyCard = isSeriesCard.boolValue?YES: NO;
            payModel.productId = product_id;
            appdel.buyVideoId = nil;
            [appdel.payManager startSearisPay:payModel];
            orderBlock(payModel);
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];
}


+ (void)buyKSinglecvideoId:(NSString *)videoId product_id:(NSString *)product_id getOrderBlock:(orderBlock _Nullable)orderBlock{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

    [parm setObject:videoId forKey:@"videoId"];
    [parm setObject:@"3" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    AppDelegate *appdel1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel1.pushBuySuccess = YES;
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            SXOrderStatusModel *payModel = [SXOrderStatusModel mj_objectWithKeyValues:dict[@"data"]];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.isBuyCard = NO;
            payModel.productId = product_id;
            appdel.buyVideoId = videoId;
            [appdel.payManager startSearisPay:payModel];
            orderBlock(payModel);
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];
}

+ (void)buyKSyvideoseriesId:(NSString *)seriesId product_id:(NSString *)product_id money:(NSString *)money getOrderBlock:(orderBlock _Nullable)orderBlock{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

    [parm setObject:seriesId forKey:@"seriesId"];
    [parm setObject:@"3" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:money forKey:@"surplusSeriesPrice"];

    AppDelegate *appdel1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel1.pushBuySuccess = YES;
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            
            SXOrderStatusModel *payModel = [SXOrderStatusModel mj_objectWithKeyValues:dict[@"data"]];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.isBuyCard = NO;
            payModel.productId = product_id;
            appdel.buyVideoId = nil;
            [appdel.payManager startSearisPay:payModel];
            orderBlock(payModel);
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];
}
@end
