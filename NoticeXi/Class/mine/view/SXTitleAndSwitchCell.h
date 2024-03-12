//
//  SXTitleAndSwitchCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "MySwitch.h"
@protocol SXSwitchChoiceDelegate <NSObject>

- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section;

@end
NS_ASSUME_NONNULL_BEGIN

@interface SXTitleAndSwitchCell : BaseCell
@property (nonatomic, strong) UILabel *mainL;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, assign) NSInteger choiceTag;
@property (nonatomic, assign) NSInteger choiceSection;
@property (nonatomic, weak) id<SXSwitchChoiceDelegate>delegate;
@property (nonatomic, strong) MySwitch *mySwitch;
@property (nonatomic, strong) UIView *backView;
@end

NS_ASSUME_NONNULL_END
