//
//  SXSpulyShopView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXSpulyShopView : UIView

@property (nonatomic, strong) UIButton *supplyButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic,copy) void(^lookRuleBlock)(BOOL lookRule);
@property (nonatomic, assign) BOOL canSupply;
@property (nonatomic, strong) UILabel *markL;
- (void)showSupplyView;
@end

NS_ASSUME_NONNULL_END
