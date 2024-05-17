//
//  SXChoiceShopOpenTimeView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXChoiceShopOpenTimeView : UIView

@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) UIView *endView;
@property (nonatomic, strong) UILabel *startTimeL;
@property (nonatomic, strong) UILabel *endTimeL;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic,copy) void(^choiceTimeBlock)(NSString *startTime,NSString *endTime);

- (void)showATView;
@end

NS_ASSUME_NONNULL_END
