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

+(CGFloat)getHeightWithLineHight:(CGFloat)lineHeight font:(CGFloat)font width:(CGFloat)width string:(NSString *)string andFirstWidth:(CGFloat)firstWidth{
    if (!string) {
        return 0;
    }

    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.firstLineHeadIndent = firstWidth;
    [paragraphStyle setLineSpacing:lineHeight];
    [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    CGRect sizestring = [string boundingRectWithSize:CGSizeMake(width,9999999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:XGBoldFontName size:font],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
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

+ (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    
    return currentTimeString;
}

+ (NSString *)updateTimeForRowWithNoHourAndMin:(NSString *)createTimeString{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[createTimeString floatValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    //秒转分钟
    NSInteger small = time / 60;
    if(small <= 0) {
        return @"刚刚";
        
    }
    if(small < 60) {
        return [NSString stringWithFormat:@"%ld%@",(long)small >0?(long)small:1,@"分钟前"];
        
    }

    // 秒转小时
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    NSDate *date = [outputFormatter dateFromString:string];
    

    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    if (isYesterday) {
        return @"昨天";
    }
    
    NSInteger hours = time/3600;
    //BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if (hours >=1 && hours <= 24) {
        return [NSString stringWithFormat:@"%ld%@",(long)hours,@"小时前"];
        
    }
    
    NSDateFormatter *tFormatter = [[NSDateFormatter alloc] init];
    [tFormatter setLocale:[NSLocale currentLocale]];
    [tFormatter setDateFormat:@"yyyy"];
    
    if ([[NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]] isEqualToString:[NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]]]]) {
        [tFormatter setDateFormat:@"MM-dd"];
        return [NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
    }
    [tFormatter setDateFormat:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
}



+ (void)savePayInfo:(NoticeByOfOrderModel *)payInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[payInfo mj_keyValues] forKey:[NSString stringWithFormat:@"callorderinfo%@",[NoticeTools getuserId]]];
    [userDefaults synchronize];
}

+ (NoticeByOfOrderModel *)getPayInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:[NSString stringWithFormat:@"callorderinfo%@",[NoticeTools getuserId]]];
    return [NoticeByOfOrderModel mj_objectWithKeyValues:userInfoDic];
}

+ (void)clearPayInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:[NSString stringWithFormat:@"callorderinfo%@",[NoticeTools getuserId]]];
}

+ (BOOL)isFirstuseOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"firstin%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkFornofirst{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"firstin%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isCanShow:(NSString *)showKey{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:showKey] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setCanNotShow:(NSString *)showKey{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:showKey];
    [cache synchronize];
}

+ (BOOL)isHowTouseOnThisDeveice{
    
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
 
    if ([[cache objectForKey:@"howuse"] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setKnowUse{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:@"howuse"];
    [cache synchronize];
}

+ (void)saveLocalToken:(NSString *)token{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"localtoken"];
    [userDefaults synchronize];
}

+ (NSString *)getLocalToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userInfoDic  = [userDefaults objectForKey:@"localtoken"];
    return userInfoDic;
}

+ (void)removeLocalToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"localtoken"];
}
@end
