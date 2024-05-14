//
//  SXAddNewsGoods2Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXAddNewsGoods2Cell : BaseCell<UITextFieldDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, copy)  void(^nameBlock)(NSString *name);
@end

NS_ASSUME_NONNULL_END
