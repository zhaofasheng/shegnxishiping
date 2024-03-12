//
//  NoticeChangeBokeController.h
//  NoticeXi
//
//  Created by li lei on 2023/12/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeBokeController : NoticeBaseListController
@property (nonatomic, strong) NSString *induce;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *bokeId;
@property (nonatomic, copy) void(^changeBokeIntroBlock)(NSString *intro,NSString *bokeId,NSString *coverUrl);
@end

NS_ASSUME_NONNULL_END
