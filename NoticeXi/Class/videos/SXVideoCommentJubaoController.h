//
//  SXVideoCommentJubaoController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCommentJubaoController : NoticeBaseCellController

@property (nonatomic, strong) NSMutableArray *jubArr;
@property (nonatomic, strong) NSMutableArray *reoceArr;
@property (nonatomic, strong) SXVideosModel *videoM;
@property (nonatomic, strong) NSString *jubaoId;
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) SXShopSayListModel *dynamicM;
@end

NS_ASSUME_NONNULL_END
