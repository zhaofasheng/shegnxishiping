//
//  SXBuySeriesTypeTools.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXBuySeriesTypeTools : UIView

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *oricePriceL;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic,copy) void(^typeClickBlock)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
