//
//  AppDelegate+Share.h
//  XGFamilyTerminal
//
//  Created by 赵小二 on 2018/7/24.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Share)

- (void)regreiteShare;
- (void)pushVideoDetail:(NSString *)videoId;
- (void)pushToKc:(NSString *)seriseId;
- (void)pushToShop:(NSString *)shopId userId:(NSString *)userId;
@end
