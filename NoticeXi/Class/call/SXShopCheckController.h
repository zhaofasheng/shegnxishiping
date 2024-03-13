//
//  SXShopCheckController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopCheckController : NoticeBaseCellController

@property (nonatomic, assign) NSInteger type;//1学历认证审核中，2学历认证完成，3资格认证审核中，4资格认证完成，5职业认证完成
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@end

NS_ASSUME_NONNULL_END
