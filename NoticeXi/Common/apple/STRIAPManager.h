//
//  STRIAPManager.h
//  NoticeXi
//
//  Created by li lei on 2021/9/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//


/*注意事项：
1.沙盒环境测试appStore内购流程的时候，请使用没越狱的设备。
2.请务必使用真机来测试，一切以真机为准。
3.项目的Bundle identifier需要与您申请AppID时填写的bundleID一致，不然会无法请求到商品信息。
4.如果是你自己的设备上已经绑定了自己的AppleID账号请先注销掉,否则你哭爹喊娘都不知道是怎么回事。
5.订单校验 苹果审核app时，仍然在沙盒环境下测试，所以需要先进行正式环境验证，如果发现是沙盒环境则转到沙盒验证。
识别沙盒环境订单方法：
 1.根据字段 environment = sandbox。
 2.根据验证接口返回的状态码,如果status=21007，则表示当前为沙盒环境。
 苹果反馈的状态码：
 21000App Store无法读取你提供的JSON数据
 21002 订单数据不符合格式
 21003 订单无法被验证
 21004 你提供的共享密钥和账户的共享密钥不一致
 21005 订单服务器当前不可用
 21006 订单是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
 21007 订单信息是测试用（sandbox），但却被发送到产品环境中验证
 21008 订单信息是产品环境中使用，但却被发送到测试环境中验证
 */
 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NoticeActShowView.h"
#import "SXOrderStatusModel.h"
typedef enum {
    SIAPPurchSuccess = 0,       // 购买成功
    SIAPPurchFailed = 1,        // 购买失败
    SIAPPurchCancle = 2,        // 取消购买
    SIAPPurchVerFailed = 3,     // 订单校验失败
    SIAPPurchVerSuccess = 4,    // 订单校验成功
    SIAPPurchNotArrow = 5,      // 不允许内购
}SIAPPurchType;
 
typedef void (^IAPCompletionHandle)(SIAPPurchType type,NSData *data);
 
 
@interface STRIAPManager : NSObject
+ (instancetype)shareSIAPManager;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *noteType;

//开始内购
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle;

//送等级专用
- (void)startPurchWithID:(NSString *)purchID money:(NSString *)money toUserId:(NSString *)userId userNum:(NSString *)userNum isNiming:(NSString *)isNiming completeHandle:(IAPCompletionHandle)handle;
- (void)startSearisPay:(SXOrderStatusModel *)payModel;

@end

