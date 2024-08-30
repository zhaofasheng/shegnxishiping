//
//  NoticerUserShopDetailHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticerUserShopDetailHeaderView : UIView
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, assign) NSInteger goodsNum;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UIImageView *playImageV;
@property (nonatomic, strong) UILabel *checkL;
@property (nonatomic, strong) UIView *backcontentView;

@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *goodsNumL;
@property (nonatomic, strong) UILabel *searvNumL;
@property (nonatomic, strong) UILabel *comNumL;


@property (nonatomic, assign) NSInteger allTime;
@property (nonatomic, strong) UIView *workIngView;

@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, copy) NSString * __nullable timerName;
@property (nonatomic, strong) UIImageView *yhImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tagsL;
@property (nonatomic, strong) UILabel *stroryL;
@property (nonatomic, strong) UIView *severceView;
@property (nonatomic, strong) UILabel *severTimeL;

@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
- (void)stopPlay;
@end

NS_ASSUME_NONNULL_END
