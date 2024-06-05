//
//  SXHowToUseView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXHowToUseView : UIImageView
@property (nonatomic, strong) UIImageView *contentView;
- (void)showInfoView;
@end

NS_ASSUME_NONNULL_END
