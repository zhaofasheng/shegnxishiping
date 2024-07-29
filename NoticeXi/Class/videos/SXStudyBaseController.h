//
//  SXStudyBaseController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXStudyBaseController : NoticeBaseController

@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic,copy) void(^buySuccessBlock)(NSString *searisID,NSString *buyNum,NSString *is_Bount);

@end

NS_ASSUME_NONNULL_END
