//
//  SXHasNewKcModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXHasUpdateKcModel : NSObject
@property (nonatomic, strong) NSString *type;//0=没有 1=1个新课程 2=多个新课程
@property (nonatomic, strong) NSString *seriesId;//课程ID ,type = 1 才返回该字段
@end

NS_ASSUME_NONNULL_END
