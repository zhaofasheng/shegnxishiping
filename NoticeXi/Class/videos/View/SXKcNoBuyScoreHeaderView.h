//
//  SXKcNoBuyScoreHeaderView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXKcNoBuyScoreHeaderView : UIView
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *intoImageView;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UILabel *scoreL;
@property (nonatomic, strong) UILabel *scoreDecL;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) XLCycleCollectionView *cyleView;
@property (nonatomic, assign) BOOL hasRequested;
@end

NS_ASSUME_NONNULL_END
