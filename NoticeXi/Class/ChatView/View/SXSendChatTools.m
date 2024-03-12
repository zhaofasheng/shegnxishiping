//
//  SXSendChatTools.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSendChatTools.h"

@implementation SXSendChatTools

- (NSMutableDictionary *)sendDic{
    if(!_sendDic){
        _sendDic = [NSMutableDictionary new];
        [_sendDic setObject:self.toUser ? self.toUser : @"noNet" forKey:@"to"];
        [_sendDic setObject:@"singleChat" forKey:@"flag"];
    }
    return _sendDic;
}

- (void)sendImgWithPath:(NSString *)path success:(BOOL)success bucketid:(NSString *)bucketId{

    
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"2" forKey:@"dialogContentType"];
    if (bucketId) {
        [messageDic setObject:bucketId forKey:@"bucketId"];
    }
    [messageDic setObject:path forKey:@"dialogContentUri"];
    [messageDic setObject:@"10" forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
     AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendVocieWith:(NSString *)localPath time:(NSString *)timeLength upSuccessPath:(NSString *)upSuccessPath success:(BOOL)success bucketid:(NSString *)bucketId{
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    if (bucketId) {
        [messageDic setObject:bucketId forKey:@"bucketId"];
    }
    [messageDic setObject:@"1" forKey:@"dialogContentType"];
    [messageDic setObject:upSuccessPath forKey:@"dialogContentUri"];

 
    [messageDic setObject:timeLength forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendemtionWithPath:(NSString *)path bucketid:(NSString *)bucketId pictureId:(NSString *)pictureId isHot:(BOOL)isHot{
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"2" forKey:@"dialogContentType"];
    [messageDic setObject:bucketId forKey:@"bucketId"];
    [messageDic setObject:path forKey:@"dialogContentUri"];
    [messageDic setObject: @"10" forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
     AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendTextWith:(NSString *)text{
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"11" forKey:@"dialogContentType"];
    [messageDic setObject:text forKey:@"dialogContentText"];
    [messageDic setObject:@"" forKey:@"dialogContentUri"];
    [messageDic setObject:@"10" forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
     AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendDic];
}
@end
