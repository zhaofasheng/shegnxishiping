//
//  SXConfigModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXConfigModel.h"

@implementation SXConfigModel

- (void)setWebsiteBuySeriesUrl:(NSDictionary *)websiteBuySeriesUrl{
    _websiteBuySeriesUrl = websiteBuySeriesUrl;
    self.webBuyModel = [SXConfigModel mj_objectWithKeyValues:websiteBuySeriesUrl];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"countNum":@"count"};
}
@end
