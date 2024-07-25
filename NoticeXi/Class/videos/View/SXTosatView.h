//
//  SXTosatView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SXTosatView : UIView
//弹窗
@property (nonatomic,retain) UIView * _Nullable alertView;
//title
@property (nonatomic,retain) UILabel * _Nullable titleLbl;

- (void)showSXToast;

@property (nonatomic, strong) NSTimer * _Nullable timer;
@property (nonatomic, strong) FSCustomButton *button;
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) void(^lookSaveListBlock)(BOOL look);

@end

NS_ASSUME_NONNULL_END
