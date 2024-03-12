//
//  NoticeWallCollectionViewCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeShopDataIdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWallCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *addPhotosButton;
@property (nonatomic, strong) NoticeShopDataIdModel *photoModel;
@end

NS_ASSUME_NONNULL_END
