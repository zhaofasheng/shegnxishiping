//
//  SXVideosModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideosModel.h"

@implementation SXVideosModel


- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.nomerHeight = GET_STRHEIGHT(title, 13, (DR_SCREEN_WIDTH-15)/2-18);
    if (self.nomerHeight > 36) {
        self.nomerHeight = 36;
    }
    
    self.titleHeight = [SXTools getHeightWithLineHight:3 font:16 width:DR_SCREEN_WIDTH-30 string:title isJiacu:YES];
    self.titleAttStr = [NoticeTools getStringWithLineHight:3 string:title];
}

- (void)setIntroduce:(NSString *)introduce{
    _introduce = introduce;
    self.introHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-30 string:introduce isJiacu:NO];
    self.introAttStr = [SXTools getStringWithLineHight:3 string:introduce];
}

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.userModel = [SXUserModel mj_objectWithKeyValues:user_info];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"vid":@"id"};
}

@end
