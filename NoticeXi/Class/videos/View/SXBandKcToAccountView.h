//
//  SXBandKcToAccountView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQCountdownButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBandKcToAccountView : UIView<CQCountDownButtonDataSource, CQCountDownButtonDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sendButton;
@property (strong, nonatomic) UITextField *codeView;
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NoticeAreaModel *areaModel;
@property (strong, nonatomic) UIButton *areaBtn;
@property (strong, nonatomic) CQCountdownButton *getCodeBtn;
@property (nonatomic,copy) void(^choiceAreaBolck)(BOOL choiceArea);

- (void)showView;
@end

NS_ASSUME_NONNULL_END
