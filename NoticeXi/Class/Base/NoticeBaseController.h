//
//  NoticeBaseController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTitleAndImageCell.h"
#import <MJRefresh.h>
#import "AppDelegate.h"
#import "UIImage+Color.h"
#import "NoticeCustumeNavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBaseController : UIViewController
@property (nonatomic, assign) BOOL useSystemeNav;//是否使用系统导航栏
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
- (void)hasNetWork;
- (void)backClick;
@end

NS_ASSUME_NONNULL_END
