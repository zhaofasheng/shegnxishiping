//
//  NoticeChangeShopIconController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeShopIconController : NoticeBaseCellController
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, copy) void(^choiceBlock)(NSString * imageUrl,UIImage *image);
@property (nonatomic, strong) UIImage *choiceImage;
@property (nonatomic, assign) BOOL isChoiceGoods;
@end

NS_ASSUME_NONNULL_END
