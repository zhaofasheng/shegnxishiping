//
//  SXHistoryModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXHistoryModel : NSObject

@property (nonatomic, strong) NSString *isUpgraded;//是否升级过(1是0否)
@property (nonatomic, strong) NSString *isRepeated;//是否重复提交(1是0否)

@end

NS_ASSUME_NONNULL_END
