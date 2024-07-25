//
//  SXkcCardListCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXKcCardListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXkcCardListCell : BaseCell
@property (nonatomic, strong) SXKcCardListModel *cardModel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL isGet;//是否是获取收到的礼品卡
@end

NS_ASSUME_NONNULL_END
