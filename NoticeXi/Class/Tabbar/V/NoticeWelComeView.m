//
//  NoticeWelComeView.m
//  NoticeXi
//
//  Created by li lei on 2021/10/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWelComeView.h"
#import "YQAnimationLayer.h"
@implementation NoticeWelComeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self SetupEmitter];
        
        [YQAnimationLayer createAnimationLayerWithString:[[NoticeSaveModel getUserInfo] nick_name] andRect: CGRectMake(0, NAVIGATION_BAR_HEIGHT+100, self.frame.size.width, self.frame.size.width) andView:self andFont:[UIFont boldSystemFontOfSize:20] andStrokeColor:[UIColor cyanColor]];
            
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)disTap{
    [self removeFromSuperview];
}

- (void)show{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
}

- (void)snow{
    // 雪花／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2.0, -30);
    snowEmitter.emitterSize        = CGSizeMake(self.bounds.size.width * 2.0, 0.0);
    
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode        = kCAEmitterLayerOutline;
    snowEmitter.emitterShape    = kCAEmitterLayerLine;
    
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    //    随机颗粒的大小
    snowflake.scale = 0.2;
    snowflake.scaleRange = 0.5;
    
    //    缩放比列速度
    //        snowflake.scaleSpeed = 0.1;
    
    //    粒子参数的速度乘数因子；
    snowflake.birthRate        = 20.0;
    
    //生命周期
    snowflake.lifetime        = 60.0;
    
    //    粒子速度
    snowflake.velocity        = 20;                // falling down slowly
    snowflake.velocityRange = 10;
    //    粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    
    //    周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;        // some variation in angle
    //    自动旋转
    snowflake.spinRange        = 0.25 * M_PI;        // slow spin
    
    snowflake.contents        = (id) [[UIImage imageNamed:@"fire"] CGImage];
    snowflake.color            = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.layer addSublayer:snowEmitter];
    
    //    [self.view.layer insertSublayer:snowEmitter atIndex:0];
    //// 雪花／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    //// 雪花／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
}


- (void)SetupEmitter{
    // Cells spawn in the bottom, moving up
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize    = CGSizeMake(1, 0.0);
    fireworksEmitter.emitterMode    = kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape    = kCAEmitterLayerLine;
    fireworksEmitter.renderMode        = kCAEmitterLayerAdditive;
    //fireworksEmitter.seed = 500;//(arc4random()%100)+300;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate        = 6.0;
    rocket.emissionRange    = 0.12 * M_PI;  // some variation in angle
    rocket.velocity            = 500;
    rocket.velocityRange    = 150;
    rocket.yAcceleration    = 0;
    rocket.lifetime            = 2.02;    // we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents            = (id) [[UIImage imageNamed:@"ball"] CGImage];
    rocket.scale            = 0.2;
    //    rocket.color            = [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    rocket.greenRange        = 1.0;        // different colors
    rocket.redRange            = 1.0;
    rocket.blueRange        = 1.0;
    
    rocket.spinRange        = M_PI;        // slow spin
    
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate            = 1.0;        // at the end of travel
    burst.velocity            = 0;
    burst.scale                = 2.5;
    burst.redSpeed            =-1.5;        // shifting
    burst.blueSpeed            =+1.5;        // shifting
    burst.greenSpeed        =+1.0;        // shifting
    burst.lifetime            = 0.35;
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 666;
    spark.velocity            = 125;
    spark.emissionRange        = 2* M_PI;    // 360 deg
    spark.yAcceleration        = 75;        // gravity
    spark.lifetime            = 3;
    
    spark.contents            = (id) [[UIImage imageNamed:@"fire"] CGImage];
    spark.scale                =0.5;
    spark.scaleSpeed        =-0.2;
    spark.greenSpeed        =-0.1;
    spark.redSpeed            = 0.4;
    spark.blueSpeed            =-0.1;
    spark.alphaSpeed        =-0.5;
    spark.spin                = 2* M_PI;
    spark.spinRange            = 2* M_PI;
    
    // putting it together
    fireworksEmitter.emitterCells    = [NSArray arrayWithObject:rocket];
    rocket.emitterCells                = [NSArray arrayWithObject:burst];
    burst.emitterCells                = [NSArray arrayWithObject:spark];
    [self.layer addSublayer:fireworksEmitter];

}

- (CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y //纵向移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animation.toValue = y;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}


- (CAAnimation *)SetupScaleAnimation{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleAnimation.duration = 3.0;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:40.0];
    //scaleAnimation.repeatCount = MAXFLOAT;
    //scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    
    return scaleAnimation;
}

- (CAAnimation *)SetupGroupAnimation{
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 3.0;
    groupAnimation.animations = @[[self moveY:3.0f Y:[NSNumber numberWithFloat:-300.0f]]];
    //groupAnimation.autoreverses = YES;
    //groupAnimation.repeatCount = MAXFLOAT;
    return groupAnimation;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
