//
//  SXPlayPayVideoDetailHeaderView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"
#import "SXPayForVideoModel.h"
#import "SXSearisVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPlayPayVideoDetailHeaderView : UIView
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) SXSearisVideoListModel *videoModel;
@property (nonatomic, strong) CBAutoScrollLabel *titleL;
@property (nonatomic, strong) UILabel *videoNameL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) SXPayForVideoModel *model;
@end

NS_ASSUME_NONNULL_END
