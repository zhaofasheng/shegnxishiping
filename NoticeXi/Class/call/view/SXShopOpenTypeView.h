//
//  SXShopOpenTypeView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXChoiceShopOpenTimeView.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopOpenTypeView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIImageView *choiceImageView1;
@property (nonatomic, strong) UIView *allView;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) SXChoiceShopOpenTimeView *openTimeView;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, assign) NSInteger originType;
- (void)showATView;
@end

NS_ASSUME_NONNULL_END
