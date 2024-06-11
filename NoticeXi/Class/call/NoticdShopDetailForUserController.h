//
//  NoticdShopDetailForUserController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"
#import "NoticeMyShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticdShopDetailForUserController : NoticeBaseController

@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic,copy) void(^cancelLikeBolck)(NSString *shopId);

@end

NS_ASSUME_NONNULL_END
