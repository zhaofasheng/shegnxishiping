//
//  SXPayVideoPlayDetailListController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "JXPagerView.h"
#import "SXSearisVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayVideoPlayDetailListController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) SXSearisVideoListModel *currentPlayModel;
@property (nonatomic, strong) NSMutableArray *searisArr;
@property (nonatomic, copy) void(^choiceVideoBlock)(SXSearisVideoListModel *videoModel);

@end

NS_ASSUME_NONNULL_END
