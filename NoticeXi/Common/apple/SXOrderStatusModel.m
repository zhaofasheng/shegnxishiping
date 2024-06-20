//
//  SXOrderStatusModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/21.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXOrderStatusModel.h"

@implementation SXOrderStatusModel

- (void)setPay_time:(NSString *)pay_time{
    _pay_time = [NoticeTools timeDataAppointFormatterWithTime:pay_time.integerValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
    
}

@end
