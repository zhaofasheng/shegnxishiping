//
//  NoticeShopContentView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopContentView : UIView

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *dataL;
@property (nonatomic, assign) NSInteger type;//1服务过的订单 2买过的记录 3我的钱包
@end

NS_ASSUME_NONNULL_END
