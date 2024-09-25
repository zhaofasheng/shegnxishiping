//
//  SXBuyKcMarkView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXBuyKcMarkView : UIView

@property (nonatomic, strong) UILabel *titleL1;
@property (nonatomic, strong) UILabel *titleL2;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, assign) BOOL showMoney;
@property (nonatomic, assign) NSInteger buyType;//0不展示，1买自己或者送人，2只给自己买，3送人
@property (nonatomic, strong) FSCustomButton *selfBuyBtn;
@property (nonatomic, strong) FSCustomButton *sendBtn;
@property (nonatomic,copy) void(^buyTypeBlock)(BOOL isbuySend);
@property (nonatomic, strong) UILabel *markL;

- (void)buyself;
- (void)buySend;
@end

NS_ASSUME_NONNULL_END
