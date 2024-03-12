//
//  SXSearisVideoListModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSearisVideoListModel.h"

@implementation SXSearisVideoListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"videoId":@"id"};
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleAtt = [SXTools getStringWithLineHight:3 string:title];
    self.titleHeight = [SXTools getHeightWithLineHight:3 font:20 width:DR_SCREEN_WIDTH-25 string:title isJiacu:YES];
    if (self.titleHeight < 28) {
        self.titleHeight = 28;
    }
}

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.userModel = [SXUserModel mj_objectWithKeyValues:user_info];
}
@end
