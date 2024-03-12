//
//  SXZiGeCheckController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXZiGeCheckController : NoticeBaseCellController
@property (nonatomic,copy) void(^upsuccessBlock)(NSInteger type);
@end

NS_ASSUME_NONNULL_END
