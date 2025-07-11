//
//  NoticeCustumeNavView.h
//  NoticeXi
//
//  Created by li lei on 2021/8/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustumeNavView : UIView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,copy) void(^rightTapBlock)(BOOL tapRight);
@property (nonatomic, strong) UILabel *rightL;
@property (nonatomic, assign) BOOL needDetailButton;
@end

NS_ASSUME_NONNULL_END
