//
//  NoticePhotoWallCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeShopDataIdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePhotoWallCell : BaseCell
@property (nonatomic, assign) BOOL canChoice;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NoticeShopDataIdModel *photoModel;
@end

NS_ASSUME_NONNULL_END
