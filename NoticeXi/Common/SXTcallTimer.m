//
//  SXTcallTimer.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTcallTimer.h"

@implementation SXTcallTimer


static NSMutableDictionary *gCallKitTimers6;
dispatch_semaphore_t callKitTimerSemaphore6;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gCallKitTimers6 = [NSMutableDictionary dictionary];
        callKitTimerSemaphore6 = dispatch_semaphore_create(1);
    });
}

+ (NSString *)timerTask:(void(^)(void))task
                  start:(NSTimeInterval)start
               interval:(NSTimeInterval)interval
                repeats:(BOOL)repeats
                  async:(BOOL)async {
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_semaphore_wait(callKitTimerSemaphore6, DISPATCH_TIME_FOREVER);
    NSString *timerName = [NSString stringWithFormat:@"%zd", gCallKitTimers6.count];
    gCallKitTimers6[timerName] = timer;
    dispatch_semaphore_signal(callKitTimerSemaphore6);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self deleteTimer:timerName];
        }
    });
    dispatch_resume(timer);
    DRLog(@"开启定时器%@",timerName);
    return timerName;
}

+ (void)deleteTimer:(NSString *)timerName{
    if (timerName.length == 0) {
        return;
    }
    DRLog(@"取消计时器%@",timerName);
    dispatch_semaphore_wait(callKitTimerSemaphore6, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = gCallKitTimers6[timerName];
    
    if (timer) {
        dispatch_source_cancel(timer);
        [gCallKitTimers6 removeObjectForKey:timerName];
    }
    
    dispatch_semaphore_signal(callKitTimerSemaphore6);
}

@end
