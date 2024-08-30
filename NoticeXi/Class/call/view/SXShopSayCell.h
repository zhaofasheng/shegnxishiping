//
//  SXShopSayCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayCell : BaseCell

@property (nonatomic, strong) SXShopSayListModel *model;

@property (nonatomic, strong) UIView *backcontentView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *contentL;

@property (nonatomic, strong) UIImageView *sayImageView1;
@property (nonatomic, strong) UIImageView *sayImageView2;
@property (nonatomic, strong) UIImageView *sayImageView3;

@property (nonatomic, strong) UIView *funView;
@property (nonatomic, strong) UIImageView *tuijianImageV;
@property (nonatomic, strong) UILabel *tuijianL;

@property (nonatomic, strong) UILabel *comNumL;
@property (nonatomic, strong) UIImageView *comImageView;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;

@property (nonatomic, assign) CGFloat imageHeight;
@end

NS_ASSUME_NONNULL_END
