//
//  NoticeNewCenterNavView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewCenterNavView : UIView
@property (nonatomic, strong) UILabel *allNumL;
@property (nonatomic, copy) void(^pushBlock)(BOOL push);
@end

NS_ASSUME_NONNULL_END
