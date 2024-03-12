//
//  NoticeEditShopInfoController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditShopInfoController : NoticeBaseCellController
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, strong) NoticeMyShopModel *shopModel;

@property (nonatomic, assign) NSInteger section;
@end

NS_ASSUME_NONNULL_END
