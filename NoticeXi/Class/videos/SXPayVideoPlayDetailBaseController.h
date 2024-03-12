//
//  SXPayVideoPlayDetailBaseController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"
#import "SXPayForVideoModel.h"
#import "SXSearisVideoListModel.h"
#import "SXPayVideoPlayDetailBaseController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayVideoPlayDetailBaseController : NoticeBaseController
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) NSMutableArray *searisArr;
@property (nonatomic, strong) SXSearisVideoListModel *currentPlayModel;
@property (nonatomic,copy) void(^refreshPlayTimeBlock)(SXSearisVideoListModel *currentModel);
@property (nonatomic,copy) void(^refreshBuyPlayTimeBlock)(SXSearisVideoListModel *currentModel,SXPayForVideoModel *searModel);
@property (nonatomic,copy) void(^getVideoListBlock)(NSMutableArray *videoList,NSString *searID);
@end

NS_ASSUME_NONNULL_END
