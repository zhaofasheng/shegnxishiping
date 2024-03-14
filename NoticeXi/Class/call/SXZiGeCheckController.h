//
//  SXZiGeCheckController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXVerifyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXZiGeCheckController : NoticeBaseCellController
@property (nonatomic,copy) void(^upsuccessBlock)(NSInteger type);
@property (nonatomic, strong) SXVerifyShopModel *verifyModel;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, assign) BOOL isCheckFail;
@end

NS_ASSUME_NONNULL_END
