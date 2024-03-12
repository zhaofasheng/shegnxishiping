//
//  NoticeNoOpenShopView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNoOpenShopView : UIView
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *suppleyButton;
@property (nonatomic,copy) void (^supplyBlock)(BOOL supply);
@end

NS_ASSUME_NONNULL_END
