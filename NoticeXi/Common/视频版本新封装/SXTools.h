//
//  SXTools.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXVideosModel.h"
#import "NoticeByOfOrderModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^MyImageBlock)(UIImage * _Nullable image);
typedef void (^downSuccessBlock)(BOOL success);

@interface SXTools : NSObject
+ (NSString *)updateTimeForRowWithNoHourAndMin:(NSString *)createTimeString;
+(void)getScreenshotWithUrlAsyn:(NSURL *)url completion:(MyImageBlock)handler;
+ (CGFloat)getSXvideoListHeight:(SXVideosModel *)videoModel;

+ (NSInteger)getCurrentPlayTime:(NSString *)vid;

+ (void)setCurrentPlayTime:(NSInteger )time vid:(NSString *)vid;

+(void)saveImage:(UIImage *)image withPath:(NSString *)pathName;
+ (UIImage *)getImageWith:(NSString *)pathName;

+ (void)deleteImageWithPath:(NSString *)pathName;

+ (NSInteger)getSaveCurrentPlayTime:(NSString *)vid;

+ (void)setSaveCurrentPlayTime:(NSInteger )time vid:(NSString *)vid;

+(CGFloat)getHeightWithLineHight:(CGFloat)lineHeight font:(CGFloat)font width:(CGFloat)width string:(NSString *)string isJiacu:(BOOL)jiacu;

+ (NSMutableAttributedString *)getStringWithLineHight:(CGFloat)lineHeight string:(NSString *)string;

+ (void)getDownloadModelAndDownWithVideoModel:(SXVideosModel *)videoModel successBlcok:(downSuccessBlock _Nullable)successBlock;

//获取最近播放的课程视频
+ (NSString *)getPayPlayLastsearisId:(NSString *)searisId;

//保存最近播放的某个课程的视频名称
+ (void)setLastPayPlayVideo:(NSString *)videoName searisId:(NSString *)searisId;

+ (UIWindow *)getKeyWindow;

+ (NSString *)getCurrentTime;

//首行缩进的文本高度
+(CGFloat)getHeightWithLineHight:(CGFloat)lineHeight font:(CGFloat)font width:(CGFloat)width string:(NSString *)string andFirstWidth:(CGFloat)firstWidth;


+ (void)savePayInfo:(NoticeByOfOrderModel *)payInfo;
+ (NoticeByOfOrderModel *)getPayInfo;
+ (void)clearPayInfo;

+ (BOOL)isFirstuseOnThisDeveice;
+ (void)setMarkFornofirst;
@end

NS_ASSUME_NONNULL_END
