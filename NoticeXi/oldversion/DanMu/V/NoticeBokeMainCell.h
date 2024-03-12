//
//  NoticeBokeMainCell.h
//  NoticeXi
//
//  Created by li lei on 2022/11/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBokeMainCell : UICollectionViewCell
@property (nonatomic, strong) NoticeDanMuModel *model;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *smallImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *hotL;
@property (nonatomic, strong) UILabel *likeNumL;
@property (nonatomic, strong) UIButton *likeButton;
@end

NS_ASSUME_NONNULL_END
