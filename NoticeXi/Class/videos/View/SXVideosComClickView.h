//
//  SXVideosComClickView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SXVideosComClickView : UIView

@property (nonatomic, strong) SXVideosModel *videoModel;

@property (nonatomic, copy) void(^comClickBlock)(BOOL click);
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *markView;

@property (nonatomic, strong) UIImageView *comImageView;
@property (nonatomic, strong) UILabel *comNumL;

@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;

@property (nonatomic, strong) UIImageView *collectImageView;
@property (nonatomic, strong) UILabel *collectL;

@property (nonatomic, copy) void(^upInputcomClickBlock)(BOOL click);


@end

NS_ASSUME_NONNULL_END
