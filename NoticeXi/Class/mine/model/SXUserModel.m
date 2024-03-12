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

- (void)setUser_introduce:(NSString *)user_introduce{
    _user_introduce = user_introduce;
    self.introHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-40-32 string:user_introduce isJiacu:NO];
    self.introAtt = [SXTools getStringWithLineHight:14 string:user_introduce];
}
@end
