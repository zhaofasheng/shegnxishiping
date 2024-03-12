//
//  XLCycleCell.h
//  XLCycleCollectionViewDemo
//
//  Created by 赵发生 on 2017/3/6.
//  Copyright © 2017年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDanMuModel.h"
@interface XLCycleCell : UICollectionViewCell

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
@property (nonatomic, strong) UIButton *comBtn;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UILabel *introL;
@end
