//
//  NoticeVideoCollectionViewCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/25.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVideoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) UIImageView *videoCoverImageView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@end

NS_ASSUME_NONNULL_END
