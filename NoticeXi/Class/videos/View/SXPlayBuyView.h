//
//  SXPlayBuyView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPlayBuyView : UIView

@property (nonatomic,copy) void(^backClickBlock)(BOOL pop);
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, strong) SXSearisVideoListModel *currentPlayModel;
@property (nonatomic,copy) void(^buyClickBlock)(NSInteger type);//1单集，2全部
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *singleBtn;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) NSMutableArray *videoArr;
@property (nonatomic, assign) BOOL hasBuySingle;//是否购买过单集
@end

NS_ASSUME_NONNULL_END
