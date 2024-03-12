//
//  SXHistoryLoginView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/27.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXHistoryLoginView : UIView
@property (nonatomic,copy) void(^funClickBlock)(NSInteger type);//1返回 2登录 3其他登录方式

@end

NS_ASSUME_NONNULL_END
