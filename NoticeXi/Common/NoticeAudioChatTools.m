//
//  NoticeAudioChatTools.m
//  NoticeXi
//
//  Created by li lei on 2023/3/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAudioChatTools.h"
#import "NoticeXi-Swift.h"
#import "NoticeQiaojjieTools.h"
#import "UIWindow+TUICalling.h"

#import "NoticeYunXin.h"
#import <Bugly/Bugly.h>

static NSString *const yunxinAppKey = @"dd8114c96a13f86d8bf0f7de477d9cd9";

@interface NoticeAudioChatTools()

@property(nonatomic, assign) UInt64 calleruid;//呼叫方的uid
@property (nonatomic, strong) NSString *currentRoomId;
@property (nonatomic, assign) NSInteger chatTime;//聊天时长
@property (nonatomic, assign) NSInteger loginCount;//登录次数

@end

@implementation NoticeAudioChatTools

- (void)callToUserId:(NSString *)userId roomId:(NSInteger)roomIdNum getOrderTime:(NSString *)getOrderTime nickName:(NSString *)nickName autoNext:(BOOL)autonext averageTime:(NSInteger)averageTime isExperince:(BOOL)isExperince{
    

}

- (void)regWangyiyun{

}


- (void)setupSDK {

}

- (void)loginToYunxin:(NoticeUserInfoModel *)userInfo{

}

//获取云信toekn
- (void)loginTiYunxin:(BOOL)refresh{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        if ([NoticeSaveModel getUserInfo]) {//已经登录
            self.loginCount++;
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/yxtoken?forceUpdated=%@",[[NoticeSaveModel getUserInfo] user_id],refresh?@"1":@"0"] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        if (self.loginCount < 5) {
                            [self loginTiYunxin:YES];
                        }
                        return;
                    }
                    
                    NoticeYunXin *yunxin = [NoticeYunXin mj_objectWithKeyValues:dict[@"data"]];
                    DRLog(@"云信token>>>>%@",yunxin.token);
                    NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@获取云信token接口\n时间%@\n获取的数据%@",[NoticeTools getuserId],[SXTools getCurrentTime],dict.description] userInfo:nil];//数据上报
                    [Bugly reportExceptionWithCategory:3 name:exception.name reason:exception.reason callStack:@[[NoticeTools getNowTimeStamp]] extraInfo:@{@"d":@"1"} terminateApp:NO];
                    
                    if (yunxin.yunxin_id && yunxin.token) {
                        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
                        userInfo.yunxin_id = yunxin.yunxin_id;
                        userInfo.yunxin_token = yunxin.token;
                        [NoticeSaveModel saveUserInfo:userInfo];
                        [self loginToYunxin:userInfo];
                    }else{
                        if (self.loginCount < 5) {
                            self.loginCount++;
                            [self loginTiYunxin:YES];
                        }
                    }
                }else{
                    NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@获取云信token接口调用成功，但获取失败\n时间%@\n获取的数据%@",[NoticeTools getuserId],[SXTools getCurrentTime],dict.description] userInfo:nil];//数据上报
                    [Bugly reportExceptionWithCategory:3 name:exception.name reason:exception.reason callStack:@[[NoticeTools getNowTimeStamp]] extraInfo:@{@"d":@"1"} terminateApp:NO];
                    DRLog(@"获取云信token失败%@",dict.description);
                    if (self.loginCount < 5) {
                        self.loginCount++;
                        [self loginTiYunxin:YES];
                    }
                }
            } fail:^(NSError *error) {
                DRLog(@"获取云信接口token失败%@",error.description);
                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@获取云信token接口调用失败败\n时间%@\n失败理由%@",[NoticeTools getuserId],[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
                [Bugly reportExceptionWithCategory:3 name:exception.name reason:exception.reason callStack:@[[NoticeTools getNowTimeStamp]] extraInfo:@{@"d":@"1"} terminateApp:NO];
                if (self.loginCount < 5) {
                    self.loginCount++;
                    [self loginTiYunxin:YES];
                }
            }];
        }
    });
}

- (void)regTencent{
    [self regWangyiyun];

    self.selfUserId = [NoticeTools getuserId];
}

- (UIWindow *)callingWindow {
    if (!_callingWindow) {
        _callingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _callingWindow.windowLevel = UIWindowLevelAlert - 1;
        _callingWindow.backgroundColor = [UIColor clearColor];
    }
    return _callingWindow;
}


- (NoticeShopGetOrderTostView *)callView{
    if (!_callView) {
        _callView = [[NoticeShopGetOrderTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _callView.isAudioCalling = YES;
        __weak typeof(self) weakSelf = self;
        _callView.acceptBlock = ^(BOOL accept) {
            if(accept){
                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@点击接听按钮\n房间号%@\n时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
                [Bugly reportExceptionWithCategory:3 name:exception.name reason:exception.reason callStack:@[[NoticeTools getNowTimeStamp]] extraInfo:@{@"d":@"1"} terminateApp:NO];
                
                [[LogManager sharedInstance] logInfo:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] logStr:[NSString stringWithFormat:@"%@点击接听按钮房间号%@时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]]];
                
                [weakSelf accept];
            }else{
                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@点击拒接按钮\n房间号%@\n时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
                [Bugly reportExceptionWithCategory:3 name:exception.name reason:exception.reason callStack:@[[NoticeTools getNowTimeStamp]] extraInfo:@{@"d":@"1"} terminateApp:NO];
                
                [[LogManager sharedInstance] logInfo:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] logStr:[NSString stringWithFormat:@"%@点击拒接按钮房间号%@时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]]];
                
                [[LogManager sharedInstance] checkLogNeedUpload];
                
                [weakSelf repject:NO];
            }
        };
        
        _callView.endOpenBlock = ^(BOOL close) {
            [weakSelf repject:close];
        };
    }
    return _callView;
}

//接听
- (void)accept{
  
}

//用户杀死app的时候或者挂断的时候，调用用户取消订单
- (void)userCancelOrder{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject: @"2" forKey:@"orderType"];
    [parm setObject:self.orderModel.room_id forKey:@"roomId"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
          
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

//拒绝
- (void)repject:(BOOL)close{

}

//云信接听  当被叫 onInvited 回调发生，调用 accept 接听呼叫
- (void)acceptCall{
   
}

//获取等待的订单
- (void)getOrder{
  
}


- (void)orderFinish{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    NSInteger totalTime = self.chatTime;
    if(totalTime < 1){
        totalTime = 1;
    }
    [parm setObject:[NSString stringWithFormat:@"%d",(int)totalTime] forKey:@"second"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/complete/0/%@",self.currentRoomId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            DRLog(@"订单这设置为完成");
            self.currentRoomId = nil;
        }
    } fail:^(NSError * _Nullable error) {
    }];
    [[NoticeTools getTopViewController] hideHUD];
}


//这个是用来保持app活跃在后台
- (LGAudioPlayer *)callPlayer
{
    if (!_callPlayer) {
        _callPlayer = [[LGAudioPlayer alloc] init];
        _callPlayer.playingBlock = ^(CGFloat currentTime) {
            DRLog(@"播放来电音频%.f",currentTime);
        };
        _callPlayer.playComplete = ^{
            DRLog(@"来电音频播放停止");
        };
    }
    return _callPlayer;
}

- (void)clearCallWaitView{
    [self.callView removeFromSuperview];
    self.callingWindow.hidden = YES;
    self.callingWindow = nil;
}

@end
