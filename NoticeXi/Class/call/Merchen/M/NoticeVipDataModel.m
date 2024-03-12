//
//  NoticeVipDataModel.m
//  NoticeXi
//
//  Created by li lei on 2023/9/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipDataModel.h"

@implementation NoticeVipDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cardId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NSString stringWithFormat:@"%@：%@",[NoticeTools chinese:@"领取时间" english:@"Activation date" japan:@"受け取った時間"],[NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"]];
    
}

@end
