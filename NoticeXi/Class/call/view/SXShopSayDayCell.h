//
//  SXShopSayDayCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayDayCell : BaseCell
@property (nonatomic, strong) SXShopSayListModel *model;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *backcontentView;
@property (nonatomic, strong) UIImageView *sayImageView1;
@property (nonatomic, strong) UILabel *numL;
@end

NS_ASSUME_NONNULL_END
