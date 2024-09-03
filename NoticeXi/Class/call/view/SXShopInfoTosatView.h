//
//  SXShopInfoTosatView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
#import "NoticeCureentShopStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopInfoTosatView : UIView
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;//申请状态
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, assign) BOOL noShop;
@property (nonatomic,copy) void(^clickIconBlock)(BOOL clickIcon);
@property (nonatomic, strong) UIImageView *shopIconImageView;
@property (nonatomic, strong) UIView *intoView;
@property (nonatomic, strong) UIImageView *jiantouImgv;
@property (nonatomic, strong) UIView *workingView;
@property (nonatomic, strong) UILabel *workL;
@property (nonatomic, strong) UIView *workV;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UILabel *severNumL;
@property (nonatomic, strong) UILabel *buyL;
- (void)showInfoView;
@end

NS_ASSUME_NONNULL_END
