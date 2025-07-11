//
//  SCImageView.m
//  NoticeXi
//
//  Created by li lei on 2018/12/13.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "SCImageView.h"

@implementation SCImageView

// 开始旋转
-(void) startRotating {
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue =  [NSNumber numberWithFloat:M_PI * 2];  // 旋转一周
    rotateAnimation.duration = 5.0;                                 // 旋转时间20秒
    rotateAnimation.repeatCount = MAXFLOAT;                          // 重复次数，这里用最大次数
    self.layer.speed = 2;
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}

// 停止旋转
-(void) stopRotating {
    
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;                                          // 停止旋转
    self.layer.timeOffset = pausedTime;                              // 保存时间，恢复旋转需要用到
}

// 恢复旋转
-(void) resumeRotate {
    [self startRotating];
    if (self.layer.timeOffset == 0) {
        [self startRotating];
        return;
    }
    
//    CFTimeInterval pausedTime = self.layer.timeOffset;
//    self.layer.speed = 2;                                         // 开始旋转
//    self.layer.timeOffset = 0.0;
//    self.layer.beginTime = 0.0;
//    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
//    self.layer.beginTime = timeSincePause;                          // 从暂停的时间点开始旋转
}

// 开始旋转
-(void)startRotating1 {
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue =  [NSNumber numberWithFloat:M_PI * 2];  // 旋转一周
    rotateAnimation.duration = 1.0;                                 // 旋转时间20秒
    rotateAnimation.repeatCount = MAXFLOAT;                          // 重复次数，这里用最大次数
    self.layer.speed = 1.0;
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}

-(void)startRotatingWithTime:(CGFloat)time{
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue =  [NSNumber numberWithFloat:M_PI * 2];  // 旋转一周
    rotateAnimation.duration = time;                                 // 旋转时间20秒
    rotateAnimation.repeatCount = 1;                          // 重复次数，这里用最大次数
    self.layer.speed = 1.0;
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}

// 停止旋转
-(void) stopRotating1 {
    
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;                                          // 停止旋转
    self.layer.timeOffset = pausedTime;                              // 保存时间，恢复旋转需要用到
}

// 恢复旋转
-(void) resumeRotate1 {
    
    if (self.layer.timeOffset == 0) {
        [self startRotating1];
        return;
    }
    
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1.0;                                         // 开始旋转
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
    self.layer.beginTime = timeSincePause;                          // 从暂停的时间点开始旋转
}


@end
