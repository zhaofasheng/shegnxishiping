//
//  NoticeManagerUserAction.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerUserAction : NSObject

@property (nonatomic,strong) NSString *prohibitionTwo;//0=正常 1=禁言2小时
@property (nonatomic,strong) NSString *prohibitionFour;//0=正常 1=禁言4小时
@property (nonatomic,strong) NSString *prohibitionEight;//0=正常 1=禁言8小时
@property (nonatomic,strong) NSString *flag;//0:=正常 1=仙人掌


@end

NS_ASSUME_NONNULL_END
