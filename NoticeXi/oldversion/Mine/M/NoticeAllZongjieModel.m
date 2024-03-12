//
//  NoticeAllZongjieModel.m
//  NoticeXi
//
//  Created by li lei on 2023/12/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAllZongjieModel.h"

@implementation NoticeAllZongjieModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"user_num":@"new_user_num"};
}
- (void)setMost_user:(NSDictionary *)most_user{
    _most_user = most_user;
    self.userM = [NoticeAbout mj_objectWithKeyValues:most_user];
}

- (void)setLetter_user:(NSDictionary *)letter_user{
    _letter_user = letter_user;
    self.letterUser = [NoticeAbout mj_objectWithKeyValues:letter_user];
}

- (void)setTime_period:(NSString *)time_period{
    _time_period = time_period;
    if(_time_period.intValue == 1){
        self.time_Range = @"(0点-5点)";
        self.time_periodName = @"凌晨";
    }else if (_time_period.intValue == 2){
        self.time_Range = @"(5点-12点)";
        self.time_periodName = @"上午";
    }else if (_time_period.intValue == 3){
        self.time_Range = @"(12点-16点)";
        self.time_periodName = @"下午";
    }else{
        self.time_Range = @"(18点-24点)";
        self.time_periodName = @"晚上";
    }
}

@end
