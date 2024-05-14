//
//  SXAddNewsGoods3Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXAddNewsGoods3Cell : BaseCell<UITextFieldDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, copy)  void(^priceBlock)(NSString *price);
@end

NS_ASSUME_NONNULL_END
