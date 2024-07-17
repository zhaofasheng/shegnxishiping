//
//  SXKCBuyTypeView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXKCBuyTypeView : UIView
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic,copy) void (^buyTypeBlock)(NSInteger type);

- (void)showTost;
@end

NS_ASSUME_NONNULL_END
