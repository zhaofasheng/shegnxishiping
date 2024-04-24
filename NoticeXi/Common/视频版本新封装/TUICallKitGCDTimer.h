

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUICallKitGCDTimer : NSObject

+ (NSString *)timerTask:(void(^)(void))task
                  start:(NSTimeInterval)start
               interval:(NSTimeInterval)interval
                repeats:(BOOL)repeats
                  async:(BOOL)async;

+ (void)cancelTimer:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END
