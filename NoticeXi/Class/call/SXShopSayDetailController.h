//
//  SXShopSayDetailController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayDetailController : NoticeBaseCellController
@property (nonatomic, assign) BOOL needUpCom;
@property (nonatomic, assign) BOOL isReport;//被举报
@property (nonatomic, strong) SXShopSayListModel *model;
@property (nonatomic, strong) NSString *type;//1=普通类型列表2=定位类型列表
@property (nonatomic, strong) NSString *commentId;//评论定位类型 必传 评论ID 没有传0
@property (nonatomic, strong) NSString *replyId;//评论定位类型 必传 回复ID 没有传0
@property (nonatomic, strong) NSString *jubaoId;
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
