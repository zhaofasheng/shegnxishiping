//
//  SXShopCheckTypeCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXShopCheckTypeCell : BaseCell
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) FSCustomButton *typeButton;
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
