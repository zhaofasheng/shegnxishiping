//
//  SXShopSendCommentView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSendCommentView : UIView

@property (nonatomic, strong) SXShopSayListModel *model;
@property (nonatomic, copy) void(^upcomClickBlock)(BOOL click);
@property (nonatomic, copy) void(^comClickBlock)(BOOL click);
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *markView;

@property (nonatomic, strong) UIImageView *comImageView;
@property (nonatomic, strong) UILabel *comNumL;

@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;
@end

NS_ASSUME_NONNULL_END
