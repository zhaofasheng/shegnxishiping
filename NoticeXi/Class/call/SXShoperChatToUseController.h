//
//  SXShoperChatToUseController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXShoperChatToUseController : NoticeBaseCellController
@property (nonatomic, strong) NoticeOrderListModel *orderModel;
@property (nonatomic, assign) BOOL isFromOver;//通话结束时候点击进来的
@property (nonatomic, assign) BOOL isbuyer;//买家视角
@property (nonatomic, strong) NSDictionary *orderCommentInfo;
@property (nonatomic, strong) NSString *jubaoId;
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
