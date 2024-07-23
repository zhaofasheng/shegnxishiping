//
//  SXAddVideoZjView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXAddVideoZjView : UIView<UITextFieldDelegate>
@property (nonatomic,copy) void (^addBlock)(NSString *name,BOOL isOpen);
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *sendButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isChange;
- (void)show;
@end

NS_ASSUME_NONNULL_END
