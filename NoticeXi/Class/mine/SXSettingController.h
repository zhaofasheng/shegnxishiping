//
//  SXSettingController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXSettingController : NoticeBaseCellController
@property (nonatomic,copy) void(^needFirstBlock)(BOOL needFirst);

@end

NS_ASSUME_NONNULL_END
