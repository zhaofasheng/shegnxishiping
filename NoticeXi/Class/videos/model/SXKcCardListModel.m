//
//  SXKcCardListModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/25.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcCardListModel.h"

@implementation SXKcCardListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cardId":@"id"};
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.userM = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}

- (void)setSeries_info:(NSDictionary *)series_info{
    _series_info = series_info;
    self.searModel = [SXPayForVideoModel mj_objectWithKeyValues:series_info];
}

- (void)setTo_user_info:(NSDictionary *)to_user_info{
    _to_user_info = to_user_info;
    self.getUserInfoM = [NoticeAbout mj_objectWithKeyValues:to_user_info];
}
@end
