//
//  NoticeEditCardCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditCardCell : BaseCell
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, strong) UILabel *nameL;
@end

NS_ASSUME_NONNULL_END
