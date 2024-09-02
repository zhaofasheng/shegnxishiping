//
//  SXShopSayNavView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayNavView : UIView
@property (nonatomic, strong) SXShopSayListModel *model;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UIImageView *markImageView;
@end

NS_ASSUME_NONNULL_END
