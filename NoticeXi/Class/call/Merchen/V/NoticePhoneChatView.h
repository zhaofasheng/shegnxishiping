//
//  NoticePhoneChatView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeShopContentView.h"
#import "NoticeNoOpenShopView.h"
#import "NoticeShopStatusView.h"
#import "NoticeMyShopModel.h"
#import "NoticeCureentShopStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePhoneChatView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;//申请状态

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *shopStatusL;
@property (nonatomic, strong) UILabel *changeStyleL;
@property (nonatomic, assign) BOOL isCallPhone;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic,copy) void (^changeStyleBlock)(BOOL style);
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, assign) BOOL isDragScrollView;

@property (nonatomic, strong) NoticeShopStatusView *shopStatusView;

@property (nonatomic, strong) NSMutableArray *sellGoodsArr;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NSMutableArray *goodsArr;

@property (nonatomic, strong) NoticeNoOpenShopView *noShopView;
@property (nonatomic, strong) NoticeShopContentView *severView;
@property (nonatomic, strong) NoticeShopContentView *hasBuyView;
@property (nonatomic, strong) NoticeShopContentView *wallectView;

- (void)refreshShopStatus;
@end

NS_ASSUME_NONNULL_END
