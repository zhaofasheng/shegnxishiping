//
//  SXFullPlayInfoView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXFullPlayInfoView : UIView
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *studyView;
@property (nonatomic, strong) UILabel *studyNameL;
@property (nonatomic, strong) UILabel *buyL;
@property (nonatomic, strong) UIImageView *buyImageV;

@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *colseButton;
@property (nonatomic,copy) void(^openMoreBlock)(BOOL open);

@property (nonatomic, assign) BOOL isHasStudy;
@property (nonatomic, assign) CGFloat studyWidth;
@property (nonatomic, assign) BOOL isOpen;
@end

NS_ASSUME_NONNULL_END
