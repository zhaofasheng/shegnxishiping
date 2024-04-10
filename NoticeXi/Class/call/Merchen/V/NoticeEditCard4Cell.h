//
//  NoticeEditCard4Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditCard4Cell : BaseCell
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, strong) UIButton *addtagsButton;
@property (nonatomic, copy) void(^editShopModelBlock)(BOOL edit);

@property (nonatomic, assign) BOOL justShow;
@end

NS_ASSUME_NONNULL_END
