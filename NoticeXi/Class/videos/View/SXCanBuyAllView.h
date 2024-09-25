//
//  SXCanBuyAllView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXCanBuyAllView : UIView
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic,copy) void(^buyBlock)(BOOL buy);

- (void)showView;
@end

NS_ASSUME_NONNULL_END
