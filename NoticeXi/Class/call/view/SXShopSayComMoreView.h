//
//  SXShopSayComMoreView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXShopSayComModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayComMoreView : UITableViewHeaderFooterView
@property (nonatomic, strong) SXShopSayComModel *commentM;
@property (nonatomic, strong) FSCustomButton *moreButton;
@property (nonatomic, strong) UILabel *closeL;
@property (nonatomic,copy) void(^moreCommentBlock)(SXShopSayComModel *commentM);
@property (nonatomic,copy) void(^closeCommentBlock)(SXShopSayComModel *commentM);
@end

NS_ASSUME_NONNULL_END
