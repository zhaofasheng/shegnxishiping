//
//  SXBuySeriesTools.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPayForVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBuySeriesTools : UIView
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic,copy) void(^buytypeBlock)(NSInteger type,NSString *currentId);//1购买单集，2购买课程，3购买课程卡，4解锁3节,5解锁剩余内容
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;
@property (nonatomic, assign) BOOL justBuyAll;//只购买课程
@property (nonatomic, assign) BOOL justBuyCard;//只购买课程卡
@property (nonatomic, assign) BOOL jisugouke;//继续购课
@property (nonatomic, strong) NSString *currentId;
@property (nonatomic, strong) NSString *currentVideo;
@property (nonatomic, strong) NSMutableArray *threeIdArr;
@property (nonatomic, strong) NSMutableArray *threeNameArr;
- (void)show;
@end

NS_ASSUME_NONNULL_END
