//
//  NoticeShopGetOrderTostView.m
//  NoticeXi
//
//  Created by li lei on 2022/7/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopGetOrderTostView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "UIWindow+TUICalling.h"
#import <Bugly/Bugly.h>
@implementation NoticeShopGetOrderTostView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasKillApp) name:@"APPWASKILLED" object:nil];
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-90)/2, NAVIGATION_BAR_HEIGHT+60, 90, 90)];
        imageView.layer.cornerRadius = 45;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        imageView.image = UIImageNamed(@"Image_ordericonchant");
        [self addSubview:imageView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+23, DR_SCREEN_WIDTH, 22)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor whiteColor];
        titleL.text = @"店铺有新的订单来了";
        [self addSubview:titleL];
        _titleL = titleL;
        
        NSArray *imageArr = @[@"callimg_jujie",@"callimg_jieshou"];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-228)/2+158*i, DR_SCREEN_HEIGHT-70-BOTTOM_HEIGHT-120, 70, 70)];
            [button setBackgroundImage:UIImageNamed(imageArr[i]) forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(getOrCancel:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
      
    }
    return self;
}

- (void)hasKillApp{
    NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@杀死app拒接电话\n时间%@\n",[NoticeTools getuserId],[SXTools getCurrentTime]] userInfo:nil];//数据上报
    [Bugly reportException:exception];
    if(self.endOpenBlock){
        self.endOpenBlock(NO);
    }
}

- (void)setIsAudioCalling:(BOOL)isAudioCalling{
    _isAudioCalling = isAudioCalling;
    if(isAudioCalling){
        _titleL.text = @"店铺有新的订单来了";
    }
}

- (void)dissMiseeShow{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.hasShowCallView = NO;
    [self removeFromSuperview];
    self.hasShow = NO;
    self.callingWindow.hidden = YES;
    self.callingWindow = nil;
}

- (void)getOrCancel:(UIButton *)button{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.hasShowCallView = NO;
    if (self.isAudioCalling) {
        if (button.tag == 1) {
            if(self.acceptBlock){
                self.acceptBlock(YES);
            }
        }else{
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"确定拒绝订单吗？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
                if (buttonIndex == 1 || buttonIndex == 2) {
                    [self dissMiseeShow];
                    if(buttonIndex == 2){
                        if(self.endOpenBlock){
                            self.endOpenBlock(YES);
                        }
                    }else{
                        if(self.acceptBlock){
                            self.acceptBlock(NO);
                        }
                    }
                }
                
            } otherButtonTitleArray:@[@"拒绝",@"拒绝，并结束营业"]];
         
            [sheet show];
        }
        return;
    }
   
}

- (void)showCallView{
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view addSubview:self];
    self.hasShow = YES;
    self.callingWindow.rootViewController = viewController;
    self.callingWindow.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_callingWindow != nil) {
            [self.callingWindow t_makeKeyAndVisible];
        }
    });
    
}

- (UIWindow *)callingWindow {
    if (!_callingWindow) {
        _callingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _callingWindow.windowLevel = UIWindowLevelAlert - 1;
        _callingWindow.backgroundColor = [UIColor clearColor];
    }
    return _callingWindow;
}


@end
