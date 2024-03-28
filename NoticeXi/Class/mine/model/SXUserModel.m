//
//  SXUserModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserModel.h"

@implementation SXUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId":@"id"};
}


@end
