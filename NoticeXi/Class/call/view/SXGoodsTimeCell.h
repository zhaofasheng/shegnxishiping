//
//  SXGoodsTimeCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXGoodsInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXGoodsTimeCell : BaseCell
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) SXGoodsInfoModel *timeModel;
@end

NS_ASSUME_NONNULL_END
