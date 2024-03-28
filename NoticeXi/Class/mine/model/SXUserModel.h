//
//  SXUserModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXUserModel : NSObject
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *avatar_url;//头像地址
@property (nonatomic, strong) NSString *frequency_no;//学号
@property (nonatomic, strong) NSString *is_official;//是否为官方号(1是0否)
@property (nonatomic, strong) NSString *user_introduce;//视频作者的介绍

@end

NS_ASSUME_NONNULL_END
