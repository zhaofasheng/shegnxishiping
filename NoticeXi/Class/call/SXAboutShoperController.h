//
//  SXAboutShoperController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "JXPagerView.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXAboutShoperController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@end

NS_ASSUME_NONNULL_END
