//
//  NoticeChengjiuMonths.m
//  NoticeXi
//
//  Created by li lei on 2023/12/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChengjiuMonths.h"

@implementation NoticeChengjiuMonths

- (void)setDatas:(NSDictionary *)datas{
    _datas = datas;
    if(!datas){
        return;
    }
    self.dataModel = [NoticeChengjiuMonths mj_objectWithKeyValues:datas];
}

- (void)setGiven_month:(NSString *)given_month{
    _given_month = [NSString stringWithFormat:@"%02d",given_month.intValue];
}


@end
