//
//  SXShopLikelistCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopLikelistCell : BaseCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NoticeMyShopModel *shopM;
@property (nonatomic, strong) UIView *callView;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UIImageView *sexImageView;
@end

NS_ASSUME_NONNULL_END
