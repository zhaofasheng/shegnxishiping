//
//  SXVideoHeaderDetailView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXVideoHeaderDetailView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *sectionView;
@end

NS_ASSUME_NONNULL_END
