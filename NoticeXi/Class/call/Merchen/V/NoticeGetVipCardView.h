//
//  NoticeGetVipCardView.h
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeGetVipCardView : UIView

@property (nonatomic, copy) void(^getOrSendBlock)(BOOL isGet);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, strong) UIImageView *cardImageView;

- (void)showGetView;
@end

NS_ASSUME_NONNULL_END
