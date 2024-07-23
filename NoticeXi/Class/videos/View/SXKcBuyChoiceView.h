//
//  SXKcBuyChoiceView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXKcBuyChoiceView : UIView
- (void)show;
@property (nonatomic, assign) BOOL hasBuy;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic,copy) void(^buyTypeBolck)(BOOL isSend);

@end

NS_ASSUME_NONNULL_END
