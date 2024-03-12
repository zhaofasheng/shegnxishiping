//
//  NoticeShopStroyCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopStroyCell : BaseCell
@property (nonatomic, copy) void(^editShopModelBlock)(BOOL edit);
@property (nonatomic, strong) FSCustomButton *stroyButton;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *contentL;
@end

NS_ASSUME_NONNULL_END
