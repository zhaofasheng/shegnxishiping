//
//  NoticeUserInfoCenterController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/25.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserInfoCenterController : NoticeBaseCellController
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NSString *userId;


@end

NS_ASSUME_NONNULL_END
