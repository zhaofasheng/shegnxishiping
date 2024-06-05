//
//  SXShopChatTouserHeadere.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopChatTouserHeadere : UIView
@property (nonatomic, strong) NoticeOrderListModel *orderModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UILabel *orderL;
@property (nonatomic, strong) UILabel *timeL;
@end

NS_ASSUME_NONNULL_END
