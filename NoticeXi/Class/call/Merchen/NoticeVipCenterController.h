//
//  NoticeVipCenterController.h
//  NoticeXi
//
//  Created by li lei on 2023/8/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVipCenterController : BaseTableViewController
@property (nonatomic, assign) BOOL noSkinBlock;
@property (nonatomic, copy) void(^goUpLelveBlock)(BOOL up);
@end

NS_ASSUME_NONNULL_END
