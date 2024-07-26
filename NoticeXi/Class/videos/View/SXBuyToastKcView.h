//
//  SXBuyToastKcView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/3.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXBuyToastKcView : UIView

@property (nonatomic, strong) UIImageView *contentView;
- (void)showInfoView;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic,copy) void(^buyBolokc)(BOOL buy);

@end

NS_ASSUME_NONNULL_END
