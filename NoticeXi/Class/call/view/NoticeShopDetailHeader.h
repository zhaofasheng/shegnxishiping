//
//  NoticeShopDetailHeader.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
#import "SXNoDataDefaultShopInfoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopDetailHeader : UIView<NoticeRecordDelegate>
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UIImageView *playImageV;
@property (nonatomic, strong) UILabel *checkL;

@property (nonatomic, strong) UILabel *goodsNumL;
@property (nonatomic, strong) UILabel *searvNumL;
@property (nonatomic, strong) UILabel *comNumL;

@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, strong) UIImageView *photoImageView;


@property (nonatomic, strong) UIView *voiceView;
@property (nonatomic, strong) UIView *storyView;
@property (nonatomic, strong) UIView *tagsView;

@property (nonatomic, strong) UIImageView *intoImage1;
@property (nonatomic, strong) UIImageView *intoImage2;

@property (nonatomic, assign) NSInteger goodsNum;

@property (nonatomic, strong) SXNoDataDefaultShopInfoView *nodataView1;
@property (nonatomic, strong) SXNoDataDefaultShopInfoView *nodataView2;
@property (nonatomic, strong) SXNoDataDefaultShopInfoView *nodataView3;
@property (nonatomic, strong) SXNoDataDefaultShopInfoView *nodataView4;


@end

NS_ASSUME_NONNULL_END
