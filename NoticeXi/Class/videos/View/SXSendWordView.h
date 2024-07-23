//
//  SXSendWordView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXSendWordView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL noDissmiss;
@property (nonatomic,copy) void (^jubaoBlock)(NSString *content);
@property (nonatomic, strong) UILabel *plaL;
- (void)refreshViewHeight;
- (void)showView;
- (void)cancelClick;
@end

NS_ASSUME_NONNULL_END
