//
//  SXGoPayView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXGoPayView : UIView

- (void)showPayView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, copy) void(^surePayBlock)(BOOL pay);
@end

NS_ASSUME_NONNULL_END
