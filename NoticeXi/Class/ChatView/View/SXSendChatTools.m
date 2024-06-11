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

- (NSMutableDictionary *)sendOrderComDic{
    if (!_sendOrderComDic) {
        _sendOrderComDic = [[NSMutableDictionary alloc] init];
        [_sendOrderComDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.toUser] forKey:@"to"];
        [_sendOrderComDic setObject:@"orderComment" forKey:@"flag"];
    }
    return _sendOrderComDic;
}

- (void)sendImgWithPath:(NSString *)path success:(BOOL)success bucketid:(NSString *)bucketId{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    if (self.orderId) {
        [messageDic setObject:self.orderId forKey:@"orderId"];
        [messageDic setObject:@"2" forKey:@"resourceType"];
        [messageDic setObject:@"10" forKey:@"resourceLen"];
        [messageDic setObject:path forKey:@"resourceUri"];
        [messageDic setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
        [self.sendOrderComDic setObject:messageDic forKey:@"data"];
        [appdel.socketManager sendMessage:self.sendOrderComDic];
        return;
    }
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"2" forKey:@"dialogContentType"];
    if (bucketId) {
        [messageDic setObject:bucketId forKey:@"bucketId"];
    }
    [messageDic setObject:path forKey:@"dialogContentUri"];
    [messageDic setObject:@"10" forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];

    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendVocieWith:(NSString *)localPath time:(NSString *)timeLength upSuccessPath:(NSString *)upSuccessPath success:(BOOL)success bucketid:(NSString *)bucketId{
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.orderId) {
        [messageDic setObject:self.orderId forKey:@"orderId"];
        [messageDic setObject:@"3" forKey:@"resourceType"];
        [messageDic setObject:timeLength forKey:@"resourceLen"];
        [messageDic setObject:upSuccessPath forKey:@"resourceUri"];
        [messageDic setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
        [self.sendOrderComDic setObject:messageDic forKey:@"data"];
        [appdel.socketManager sendMessage:self.sendOrderComDic];
        return;
    }
    
    [messageDic setObject:@"0" forKey:@"voiceId"];
    if (bucketId) {
        [messageDic setObject:bucketId forKey:@"bucketId"];
    }
    [messageDic setObject:@"1" forKey:@"dialogContentType"];
    [messageDic setObject:upSuccessPath forKey:@"dialogContentUri"];

 
    [messageDic setObject:timeLength forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendemtionWithPath:(NSString *)path bucketid:(NSString *)bucketId pictureId:(NSString *)pictureId isHot:(BOOL)isHot{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    if (self.orderId) {
        [messageDic setObject:self.orderId forKey:@"orderId"];
        [messageDic setObject:@"2" forKey:@"resourceType"];
        [messageDic setObject:@"10" forKey:@"resourceLen"];
        [messageDic setObject:path forKey:@"resourceUri"];
        [messageDic setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
        [self.sendOrderComDic setObject:messageDic forKey:@"data"];
        [appdel.socketManager sendMessage:self.sendOrderComDic];
        return;
    }
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"2" forKey:@"dialogContentType"];
    [messageDic setObject:bucketId forKey:@"bucketId"];
    [messageDic setObject:path forKey:@"dialogContentUri"];
    [messageDic setObject: @"10" forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
    [appdel.socketManager sendMessage:self.sendDic];
}

- (void)sendTextWith:(NSString *)text{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    if (self.orderId) {
        [messageDic setObject:self.orderId forKey:@"orderId"];
        [messageDic setObject:@"1" forKey:@"resourceType"];
        [messageDic setObject:@"10" forKey:@"resourceLen"];
        [messageDic setObject:@"0" forKey:@"bucketId"];
        [messageDic setObject:text forKey:@"resourceUri"];
        [self.sendOrderComDic setObject:messageDic forKey:@"data"];
        [appdel.socketManager sendMessage:self.sendOrderComDic];
        return;
    }
    
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:@"11" forKey:@"dialogContentType"];
    [messageDic setObject:text forKey:@"dialogContentText"];
    [messageDic setObject:@"" forKey:@"dialogContentUri"];
    [messageDic setObject:@"10" forKey:@"dialogContentLen"];
    [self.sendDic setObject:messageDic forKey:@"data"];
    [appdel.socketManager sendMessage:self.sendDic];
}
@end
