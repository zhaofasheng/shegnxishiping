//
//  SXPlayDetailListController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBaseCollectionController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPlayDetailListController : SXBaseCollectionController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^choiceVideoBlock)(SXVideosModel *videoModel);
@property (nonatomic, strong) SXVideosModel *currentPlayModel;
@end

NS_ASSUME_NONNULL_END
