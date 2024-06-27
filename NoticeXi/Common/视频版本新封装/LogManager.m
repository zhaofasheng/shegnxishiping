//
//  LogManager.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/27.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "LogManager.h"
#import <SSZipArchive.h>

// 日志保留最大天数
static const int LogMaxSaveDay = 7;
// 日志文件保存目录
static const NSString* LogFilePath = @"/Documents/OTKLog/";
// 日志压缩包文件名
static NSString* ZipFileName = @"OTKLog.zip";

@interface LogManager()
 
// 日期格式化
@property (nonatomic,retain) NSDateFormatter* dateFormatter;
// 时间格式化
@property (nonatomic,retain) NSDateFormatter* timeFormatter;
 
// 日志的目录路径
@property (nonatomic,copy) NSString* basePath;
 
@end

@implementation LogManager


/**
 * 获取单例实例
 *
 * @return 单例实例
 */
+ (instancetype) sharedInstance{
    
    static LogManager* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LogManager alloc]init];
        }
    });
    return instance;
}

// 获取当前时间
+ (NSDate*)getCurrDate{
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}
#pragma mark - Init

- (instancetype)init{
    self = [super init];
    if (self) {
        
        // 创建日期格式化
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        // 设置时区，解决8小时
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        self.dateFormatter = dateFormatter;
        
        // 创建时间格式化
        NSDateFormatter* timeFormatter = [[NSDateFormatter alloc]init];
        [timeFormatter setDateFormat:@"HH:mm:ss"];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        self.timeFormatter = timeFormatter;
        
        // 日志的目录路径
        self.basePath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),LogFilePath];
    }
    return self;
}

#pragma mark - Method

/**
 * 写入日志
 *
 * @param module 模块名称
 * @param logStr 日志信息,动态参数
 */
- (void)logInfo:(NSString*)module logStr:(NSString*)logStr{
    
    // 异步执行
    dispatch_async(dispatch_queue_create("writeLog", nil), ^{
        
        // 获取当前日期做为文件名
        NSString* fileName = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString* filePath = [NSString stringWithFormat:@"%@%@",self.basePath,fileName];
        
        // [时间]-[模块]-日志内容
        NSString* timeStr = [self.timeFormatter stringFromDate:[LogManager getCurrDate]];
        NSString* writeStr = [NSString stringWithFormat:@"[%@]-[%@]-%@\n",timeStr,module,logStr];
        
        // 写入数据
        [self writeFile:filePath stringData:writeStr];
        
        DRLog(@"写入日志:%@",filePath);
    });
}

/**
 * 清空日志
 */
- (void)clearExpiredLog{
    
    // 获取日志目录下的所有文件
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.basePath error:nil];
    for (NSString* file in files) {
        NSDate* date = [self.dateFormatter dateFromString:file];
        if (date) {
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",self.basePath,file] error:nil];
        }
    }
}

/**
 * 检测日志是否需要上传
 */
- (void)checkLogNeedUpload{
    [self uploadLog:nil];
}

#pragma mark - Private

/**
 * 处理是否需要上传日志
 *
 * @param resultDic 包含获取日期的字典
 */
- (void)uploadLog:(NSDictionary*)resultDic{
    
    // 压缩文件是否创建成功
    BOOL created = NO;
    // 压缩日志
    created = [self compressLog:nil];
    if (created) {

        NSString* zipFilePath = [self.basePath stringByAppendingString:ZipFileName];
        
        
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:zipFilePath];
        NSData *fileData = [handle readDataToEndOfFile];
        [handle closeFile];
        if (!fileData) {
            return;
        }
        
        NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.zip",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d",arc4random() % 99999]]];//音频本地路径转换为md5字符串
        NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
        [parm1 setObject:@"8" forKey:@"resourceType"];
        [parm1 setObject:pathMd5 forKey:@"resourceContent"];
        
        [[XGUploadDateManager sharedManager] uploadTxtWithTxtData:fileData parm:parm1 progressHandler:^(CGFloat progress) {
            
        } complectionHandler:^(NSError *error, NSString *Message, NSString *bucketId, BOOL sussess) {
            if (sussess) {
                [self upDataToser:Message];
            }
        }];
        
    }
}

- (void)upDataToser:(NSString *)path{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"logType"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:path forKey:@"logUri"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"userslog/%@",[NoticeTools getuserId]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        if (success) {
            [self deleteZipFile];
            [self clearExpiredLog];
            DRLog(@"日志上传成功");
        }
    } fail:^(NSError * _Nullable error) {
        DRLog(@"日志上传失败%@",error);
    }];
}

/**
 * 压缩日志
 *
 * @param dates 日期时间段，空代表全部
 *
 * @return 执行结果
 */
- (BOOL)compressLog:(NSArray*)dates{
    
    // 先清理几天前的日志
  //  [self clearExpiredLog];
    
    // 获取日志目录下的所有文件
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.basePath error:nil];
    if (files.count <= 0) {
        return NO;
    }
    // 压缩包文件路径
    NSString * zipFile = [self.basePath stringByAppendingString:ZipFileName] ;

    return [SSZipArchive createZipFileAtPath:zipFile withContentsOfDirectory:self.basePath];
}


/**
 * 删除日志压缩文件
 */
- (void)deleteZipFile{
    
    NSString* zipFilePath = [self.basePath stringByAppendingString:ZipFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
    }
}

/**
 * 写入字符串到指定文件，默认追加内容
 *
 * @param filePath 文件路径
 * @param stringData 待写入的字符串
 */
- (void)writeFile:(NSString*)filePath stringData:(NSString*)stringData{
    
    // 待写入的数据
    NSData* writeData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // NSFileManager 用于处理文件
    BOOL createPathOk = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByDeletingLastPathComponent] isDirectory:&createPathOk]) {
        // 目录不存先创建
        [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        // 文件不存在，直接创建文件并写入
        [writeData writeToFile:filePath atomically:NO];
    }else{
        
        // NSFileHandle 用于处理文件内容
        // 读取文件到上下文，并且是更新模式
        NSFileHandle* fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        // 跳到文件末尾
        [fileHandler seekToEndOfFile];
        
        // 追加数据
        [fileHandler writeData:writeData];
        
        // 关闭文件
        [fileHandler closeFile];
    }
}

@end
