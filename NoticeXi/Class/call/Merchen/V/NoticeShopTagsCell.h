//
//  NoticeShopTagsCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopTagsCell : BaseCell
@property (nonatomic, copy) void(^editShopModelBlock)(BOOL edit);
@property (nonatomic, strong) UIButton *addtagsButton;

@property (nonatomic, copy) void(^refreshTagHeightBlock)(CGFloat height);
@end

NS_ASSUME_NONNULL_END
