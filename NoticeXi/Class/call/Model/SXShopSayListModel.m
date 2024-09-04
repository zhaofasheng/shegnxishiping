//
//  SXShopSayListModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayListModel.h"
#import "NSDate+GFCalendar.h"
@implementation SXShopSayListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"dongtaiId":@"id"};
}


- (void)setContent:(NSString *)content{
    _content = content;
    self.attStr = [SXTools getStringWithLineHight:3 string:content];
    self.contentHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-50 string:content isJiacu:NO];
    self.longcontentHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-30 string:content isJiacu:NO];
    if (content && content.length) {
        if (self.contentHeight < 36) {
            self.contentHeight = 36;
        }
        if (self.contentHeight > 110) {
            self.contentHeight = 110;
        }
        if (self.longcontentHeight < 36) {
            self.longcontentHeight = 36;
        }
    }else{
        self.contentHeight = 0;
        self.longcontentHeight = 0;
    }
}

- (void)setImg_list:(NSArray *)img_list{
    _img_list = img_list;
    self.hasImageV = img_list.count?YES:NO;
}

- (void)setShop_info:(NSDictionary *)shop_info{
    _shop_info = shop_info;
    self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:shop_info];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.created_atTime = [NoticeTools updateTimeForRow:created_at];
}

+ (void)tuijiandinapu:(NSString *)shopId tuijian:(BOOL)tuijian{
    //推荐店铺后发通知告诉动态列表和店铺详情
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopRecommend/%@/%@",shopId,tuijian?@"1":@"0"] Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (tuijian) {
                [[NoticeTools getTopViewController] showToastWithText:@"已推荐"];
            }else{
                [[NoticeTools getTopViewController] showToastWithText:@"已取消推荐"];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXtuijianshopsayNotification" object:self userInfo:@{@"shopId":shopId,@"is_tuijian":tuijian?@"1":@"0"}];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

//删除动态
+ (void)deleteDongtai:(NSString *)dontaiId{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除吗？" message:@"删除后，动态下的评论、点赞数据也会被删除" sureBtn:@"取消" cancleBtn:@"删除" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [[NoticeTools getTopViewController] showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"shop/dynamic/%@",dontaiId] Accept:@"application/vnd.shengxi.v5.8.7+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SXDeleteshopsayNotification" object:self userInfo:@{@"dongtaiId":dontaiId}];
                    [[NoticeTools getTopViewController] showToastWithText:@"删除成功"];
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];

}

- (void)setList:(NSArray *)list{
    _list = list;
    self.dtArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in list) {
        SXShopSayListModel *model = [SXShopSayListModel mj_objectWithKeyValues:dic];
        [self.dtArr addObject:model];
    }
}

- (void)setTimestamp:(NSString *)timestamp{
    _timestamp = timestamp;
    NSString *year = [NoticeTools timeDataAppointFormatterWithTime:timestamp.integerValue appointStr:@"YYYY"];
    NSString *month = [NoticeTools timeDataAppointFormatterWithTime:timestamp.integerValue appointStr:@"MM"];
    NSString *day = [NoticeTools timeDataAppointFormatterWithTime:timestamp.integerValue appointStr:@"dd"];
    
    NSString *allStr = @"";
    if (year.intValue < [[NSDate date] dateYear]) {//小于今年
        allStr = [NSString stringWithFormat:@"%@ / %@ / %@",day,month,year];
    }else{
        allStr = [NSString stringWithFormat:@"%@ / %@",day,month];
    }
    self.timeString = [DDHAttributedMode setJiaCuString:allStr setSize:18 setLengthString:day beginSize:0];
}
@end
