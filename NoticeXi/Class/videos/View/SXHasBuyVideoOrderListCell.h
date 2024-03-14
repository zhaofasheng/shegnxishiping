//
//  SXHasBuyVideoOrderListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXBuyVideoOrderList.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXHasBuyVideoOrderListCell : BaseCell
@property (nonatomic, strong) SXBuyVideoOrderList *orderListM;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *orderNumL;
@property (nonatomic, strong) UILabel *moneyL;
@end

NS_ASSUME_NONNULL_END
