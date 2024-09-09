//
//  SXShopLyStoryCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopLyStoryCell : BaseCell
@property (nonatomic, strong) NoticeOrderListModel *lyModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UILabel *orderL;
@property (nonatomic, strong) UIButton *chatTouseBtn;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, assign) BOOL is_black;//被对方拉黑了不准留言
@end

NS_ASSUME_NONNULL_END
