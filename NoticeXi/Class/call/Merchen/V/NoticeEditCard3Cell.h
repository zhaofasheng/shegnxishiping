//
//  NoticeEditCard3Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditCard3Cell : BaseCell
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, copy) void(^refreshHeightBlock)(CGFloat height);
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) NSMutableAttributedString *attStroy;

@property (nonatomic, copy) void(^editShopBlock)(BOOL edit);
@property (nonatomic, assign) BOOL justShow;
@end

NS_ASSUME_NONNULL_END
