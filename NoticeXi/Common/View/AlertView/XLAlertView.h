//
//  XLAlertView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface XLAlertView : UIView
- (void)showXLAlertView;
- (void)dissMissView;
@property (nonatomic,copy) AlertResult _Nullable resultIndex;
@property (nonatomic, copy) NSString * __nullable timerName;
//弹窗
@property (nonatomic,retain) UIView * _Nullable alertView;
//title
@property (nonatomic,retain) UILabel * _Nullable titleLbl;
//内容
@property (nonatomic,retain) UILabel * _Nullable msgLbl;
//确认按钮
@property (nonatomic,retain) UIButton * _Nullable sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton * _Nullable cancleBtn;
//横线线
@property (nonatomic,retain) UIView * _Nullable lineView;
@property (nonatomic, strong) UIImageView *backImageView;
//竖线
@property (nonatomic,retain) UIView * _Nullable verLineView;
@property (nonatomic, strong) NSString * _Nullable orderId;
@property (nonatomic, strong) NSString * _Nullable roomId;
@property (nonatomic, weak) NSTimer * _Nullable timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) BOOL autoNext;
@property (nonatomic, strong) NSString * _Nonnull name;
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title name:(NSString *_Nonnull)name time:(NSString *_Nullable)time creatTime:(NSInteger)creatTime autoNext:(BOOL)autonext;
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message callBtn:(NSString *_Nonnull)cancleTitle;
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message cancleBtn:(NSString *_Nullable)cancleTitle;
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message sureBtn:(NSString *_Nullable)sureTitle cancleBtn:(NSString *_Nonnull)cancleTitle;
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message sureBtn:(NSString *_Nullable)sureTitle cancleBtn:(NSString *_Nullable)cancleTitle right:(BOOL)right;

- (instancetype _Nullable )initNewWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message sureBtn:(NSString *_Nullable)sureTitle cancleBtn:(NSString *_Nullable)cancleTitle;

@end
