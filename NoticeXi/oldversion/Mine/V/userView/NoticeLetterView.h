//
//  NoticeLetterView.h
//  NoticeXi
//
//  Created by li lei on 2023/12/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeAllZongjieModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeLetterView : UIView
@property (nonatomic, strong) NoticeAllZongjieModel *letterModel;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) CGFloat canShowtextHeight;//原始可显示区域
@property (nonatomic, assign) CGFloat canShowUpHeight;//上高
@property (nonatomic, assign) CGFloat canShowBottomHeight;//下高
- (void)showLetterView;
@end

NS_ASSUME_NONNULL_END
