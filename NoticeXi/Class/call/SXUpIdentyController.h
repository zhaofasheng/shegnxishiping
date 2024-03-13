//
//  SXUpIdentyController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "SXVerifyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXUpIdentyController : NoticeBaseCellController

@property (nonatomic, strong) SXVerifyShopModel *verifyModel;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) UIImage *zmImage;
@property (nonatomic, strong) UIImage *fmImage;

@property (nonatomic,copy) void(^imgBlock)(UIImage *zImage,UIImage *fImage);

@end

NS_ASSUME_NONNULL_END
