//
//  NoticeShopPhotosCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeShopPhotosWall.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopPhotosCell : BaseCell
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NoticeShopPhotosWall *photosWall;
@property (nonatomic, strong) UIButton *addPhotosButton;
@property (nonatomic, copy) void(^editShopModelBlock)(BOOL edit);
@end

NS_ASSUME_NONNULL_END
