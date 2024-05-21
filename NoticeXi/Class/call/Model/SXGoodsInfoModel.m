//
//  SXGoodsInfoModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXGoodsInfoModel.h"

@implementation SXGoodsInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"category_Id":@"id"};
}

- (void)setCategory_list:(NSArray *)category_list{
    _category_list = category_list;
    self.cateArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in category_list) {
        SXGoodsInfoModel *info = [SXGoodsInfoModel mj_objectWithKeyValues:dic];
       
        [self.cateArr addObject:info];
    }
}

- (void)setCategory_name:(NSString *)category_name{
    _category_name = category_name;
    self.cateWidth = GET_STRWIDTH(category_name, 10, 18)+10;
}

- (void)setDurations:(NSArray *)durations{
    _durations = durations;
    self.timeArr = [[NSMutableArray alloc] init];
    for (NSString *time in durations) {
        SXGoodsInfoModel *timeInfo = [[SXGoodsInfoModel alloc] init];
        timeInfo.time = time;
        [self.timeArr addObject:timeInfo];
    }
}
@end
