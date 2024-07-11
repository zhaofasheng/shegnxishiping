//
//  SXZhendongTimer.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/11.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXZhendongTimer : NSObject
+ (NSString *)timerTask:(void(^)(void))task
                  start:(NSTimeInterval)start
               interval:(NSTimeInterval)interval
                repeats:(BOOL)repeats
                  async:(BOOL)async;

+ (void)deleteTimer:(NSString *)timerName;
@end

NS_ASSUME_NONNULL_END
