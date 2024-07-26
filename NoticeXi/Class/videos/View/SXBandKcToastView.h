//
//  SXBandKcToastView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXBandKcToastView : UIView
@property (nonatomic, strong) UIImageView *contentView;
- (void)showInfoView;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) NSString *canString;
@property (nonatomic, strong) NSString *noCanString;
@end

NS_ASSUME_NONNULL_END
