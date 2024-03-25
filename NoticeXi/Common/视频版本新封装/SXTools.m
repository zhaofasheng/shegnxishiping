//
//  SXTools.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTools.h"


@implementation SXTools
+(void)getScreenshotWithUrlAsyn:(NSURL *)url completion:(MyImageBlock)handler{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0, 30);
        [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
           UIImage *thumb = nil;
            if (error) {
                DRLog(@"获取视频第一帧错误 %@===%@",error,image);
            }else{
                thumb = [[UIImage alloc] initWithCGImage:image];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(thumb);
            });
        }];
    });
}

+ (CGFloat)getSXvideoListHeight:(SXVideosModel *)videoModel{
    
    CGFloat IntroHeight = videoModel.nomerHeight;
    if (IntroHeight > 40) {
        IntroHeight = 40;
    }
    
    CGFloat introSpace = 15;
    
    CGFloat imageheight =  0;
    if (videoModel.screen.intValue == 2) {
        imageheight = (DR_SCREEN_WIDTH-15)/2/3*4;
    }else{
        imageheight = (DR_SCREEN_WIDTH-15)/2/4*3;
    }
    
    CGFloat userInfoHeight = 40;
    
    return IntroHeight + imageheight + introSpace + userInfoHeight;
}

//获取在线视频当前播放进度
+ (NSInteger)getCurrentPlayTime:(NSString *)vid{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return 0;
    }
    NSString *time = [cache objectForKey:[NSString stringWithFormat:@"time%@%@",[NoticeTools getuserId],vid]];
    
    return time.integerValue;
}

//设置在线视频当前播放进度
+ (void)setCurrentPlayTime:(NSInteger )time vid:(NSString *)vid{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:[NSString stringWithFormat:@"%ld",time] forKey:[NSString stringWithFormat:@"time%@%@",[NoticeTools getuserId],vid]];
    [cache synchronize];
}

//获取缓存视频当前播放进度
+ (NSInteger)getSaveCurrentPlayTime:(NSString *)vid{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return 0;
    }
    NSString *time = [cache objectForKey:[NSString stringWithFormat:@"savetime%@%@",[NoticeTools getuserId],vid]];
    
    return time.integerValue;
}

//设置缓存视频当前播放进度
+ (void)setSaveCurrentPlayTime:(NSInteger )time vid:(NSString *)vid{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:[NSString stringWithFormat:@"%ld",time] forKey:[NSString stringWithFormat:@"savetime%@%@",[NoticeTools getuserId],vid]];
    [cache synchronize];
}


+ (UIWindow *)getKeyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

//获取最近播放的课程视频
+ (NSString *)getPayPlayLastsearisId:(NSString *)searisId{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return 0;
    }
    NSString *videoName = [cache objectForKey:[NSString stringWithFormat:@"lastVideo%@%@",[NoticeTools getuserId],searisId]];
    
    return videoName;
}

//保存最近播放的某个课程的视频名称
+ (void)setLastPayPlayVideo:(NSString *)videoName searisId:(NSString *)searisId{
    if (!videoName) {
        return;
    }
    
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:videoName forKey:[NSString stringWithFormat:@"lastVideo%@%@",[NoticeTools getuserId],searisId]];
    [cache synchronize];
}

+ (void)saveImage:(UIImage *)image withPath:(NSString *)pathName{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sximagePath"];
  
    // 拼接图片名为"currentImage.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:pathName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    }
    //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    if ([UIImageJPEGRepresentation(image, 0.5) writeToFile:imageFilePath  atomically:YES]) {

    }
}

+ (UIImage *)getImageWith:(NSString *)pathName{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sximagePath"];
  
    // 拼接图片名为"currentImage.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:pathName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){//判断createPath路径文件夹是否已存在，不存在直接返回nil
        return nil;
    }
    
    return [[UIImage alloc]initWithContentsOfFile:imageFilePath];
}

+ (void)deleteImageWithPath:(NSString *)pathName{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sximagePath"];
  
    // 拼接图片名为"currentImage.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:pathName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){//判断createPath路径文件夹是否已存在，不存在直接返回nil
        if ([[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:nil]) {
            DRLog(@"删除图片成功");
        }else{
            DRLog(@"删除图片失败");
        }
    }
}

+(CGFloat)getHeightWithLineHight:(CGFloat)lineHeight font:(CGFloat)font width:(CGFloat)width string:(NSString *)string isJiacu:(BOOL)jiacu{
    if (!string) {
        return 0;
    }

    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineHeight];
    [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    CGRect sizestring = [string boundingRectWithSize:CGSizeMake(width,9999999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:jiacu?[UIFont fontWithName:XGBoldFontName size:font] : [UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    return sizestring.size.height;
}

+ (NSMutableAttributedString *)getStringWithLineHight:(CGFloat)lineHeight string:(NSString *)string{
    if (!string) {
        return nil;
    }
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineHeight];
    [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    return string1;
}

+ (void)getDownloadModelAndDownWithVideoModel:(SXVideosModel *)videoModel successBlcok:(downSuccessBlock _Nullable)successBlock{
    if (!videoModel.video_url || videoModel.video_url.length < 10) {
        [[NoticeTools getTopViewController] showToastWithText:@"无效视频文件"];
        successBlock(NO);
        return;
    }
    
    NSArray *hasData = [[HWDataBaseManager shareManager] getAllCacheData];
    BOOL hasSave = NO;
    for (HWDownloadModel *hasDownM in hasData) {//去重，存在的就不要继续缓存
        if ([hasDownM.vid isEqualToString:videoModel.vid]) {
            hasSave = YES;
            break;
        }
    }
    
    if (hasSave) {
        [[NoticeTools getTopViewController] showToastWithText:@"当前视频已经缓存，无需重复缓存"];
        successBlock(NO);
        return;
    }
    
    if (!videoModel.screen) {
        videoModel.screen = @"1";
    }
    
    if (!videoModel.title) {
        videoModel.title = @"视频";
    }
 
    HWDownloadModel *downM = [[HWDownloadModel alloc] init];
    downM.url = videoModel.video_url;
    downM.fileName = videoModel.title;
    downM.video_len = videoModel.video_len;
    downM.videoCover = videoModel.video_cover_url;
    downM.screen = videoModel.screen;
    downM.vid = videoModel.vid;
    if (!videoModel.userModel) {
        downM.nickName = @"无名";
        downM.userId = @"0";
    }else if (videoModel.userModel.nick_name && videoModel.userModel.userId){
        downM.nickName = videoModel.userModel.nick_name;
        downM.userId = videoModel.userModel.userId;
    }else{
        downM.nickName = @"无名";
        downM.userId = @"0";
    }
//
    [[HWDownloadManager shareManager] startDownloadTask:downM];
    
    if ([[HWNetworkReachabilityManager shareManager] networkReachabilityStatus] == AFNetworkReachabilityStatusReachableViaWWAN){
        if ([[NSUserDefaults standardUserDefaults] boolForKey:HWDownloadAllowsCellularAccessKey]) {
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前正使用流量下载，如需关闭，可到【我的】-【设置】里面关闭" message:nil cancleBtn:@"好的，知道了"];
            [alerView showXLAlertView];
        }else{
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前禁止流量下载，已加进缓存队列，如需开启下载，可到【我的】-【设置】里面开启" message:nil cancleBtn:@"好的，知道了"];
            [alerView showXLAlertView];
        }
    
    }

    
    successBlock(YES);
}
@end
