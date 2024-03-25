//
//  SXDragChangeValueView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXDragChangeValueView : UIView

@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, assign) BOOL isBright;
@end

NS_ASSUME_NONNULL_END
