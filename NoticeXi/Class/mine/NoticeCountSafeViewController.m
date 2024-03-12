//
//  NoticeCountSafeViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeCountSafeViewController.h"
#import "SXSetCell.h"

#import "NoticeLabelAndSwitchCell.h"

#import "SXTitleAndSwitchCell.h"
#import "NoticeNoticenterModel.h"
#import "AppDelegate.h"
#import "NoticeLangusetViewController.h"
#import "AppDelegate+Notification.h"
#import "NoticeSetSecondPWController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "NoticeDesTroyView.h"
#import "NoticeHasLinkPhoneController.h"
@interface NoticeCountSafeViewController ()<SXSwitchChoiceDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) NSArray *switchArr;
@property (nonatomic, strong) NSArray *oswitchArr;
@property (nonatomic, strong) NSMutableArray *switchValueArr;
@property (nonatomic, assign) NSInteger numbers;
@property (nonatomic, strong) NoticeAbout *aboutM;
@property (nonatomic, assign) BOOL hasThird;
@end

@implementation NoticeCountSafeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"帐号安全";
    self.numbers = 0;
    self.switchValueArr = [NSMutableArray new];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    self.oswitchArr = @[@"微信账号：已绑定",@"QQ账号：已绑定",@"微博账号：已绑定",@"苹果账号：已绑定"];
    self.switchArr = @[[DDHAttributedMode setColorString:@"微信账号：未绑定" setColor:[UIColor colorWithHexString:@"#1FC7FF"] setLengthString:@"未绑定" beginSize:5],[DDHAttributedMode setColorString:@"QQ账号：未绑定" setColor:[UIColor colorWithHexString:@"#1FC7FF"] setLengthString:@"未绑定" beginSize:5],[DDHAttributedMode setColorString:@"微博账号：未绑定" setColor:[UIColor colorWithHexString:@"#1FC7FF"] setLengthString:@"未绑定" beginSize:5],[DDHAttributedMode setColorString:@"苹果账号：未绑定" setColor:[UIColor colorWithHexString:@"#1FC7FF"] setLengthString:@"未绑定" beginSize:5]];
    [self.tableView registerClass:[SXTitleAndSwitchCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[SXSetCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 52;
    [self request];
    [self requestCode];
    
    if (@available(iOS 13.0, *)){
        ASAuthorizationAppleIDButton *appBtn = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        [appBtn addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
    }

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 20)];
}

- (void)requestCode{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingName=login_check_switch&settingTag=other",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            if ([self.aboutM.setting_value isEqualToString:@"0"] || [self.aboutM.setting_value isEqualToString:@"2"]) {
                [self.tableView reloadData];
            }else if ([self.aboutM.setting_value isEqualToString:@"1"]){
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"loginCheckCode" Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
                    if (success1) {
                        NoticeAbout *passM = [NoticeAbout mj_objectWithKeyValues:dict1[@"data"]];
                        self.aboutM.check_code = passM.check_code;
                        self.aboutM.code_status = passM.code_status;
                        [self.tableView reloadData];
                    }
                } fail:^(NSError * _Nullable error) {
                    
                }];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)request{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/third",[[NoticeSaveModel getUserInfo]user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.numbers = 0;
            NoticeNoticenterModel *model = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            [self.switchValueArr removeAllObjects];
            if (model.bindWechat) {
                [self.switchValueArr addObject:model.bindWechat];
                self.numbers++;
            }else{
                [self.switchValueArr addObject:@"0"];
            }
            if (model.bindQQ) {
                [self.switchValueArr addObject:model.bindQQ];
                self.numbers++;
            }else{
                [self.switchValueArr addObject:@"0"];
            }
            if (model.bindWeibo) {
                [self.switchValueArr addObject:model.bindWeibo];
                self.numbers++;
            }else{
                [self.switchValueArr addObject:@"0"];
            }
            if (model.bindIos) {
                [self.switchValueArr addObject:model.bindIos];
                self.numbers++;
            }else{
                [self.switchValueArr addObject:@"0"];
            }
            [self.tableView reloadData];
        
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

#pragma SwitchChoiceDelegate
- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{
    
    if (!isOn) {
        self.numbers = 0;
        for (NSString *interS in self.switchValueArr) {
            if (interS.integerValue) {
                self.numbers++;
            }
        }
        
        if ([[[NoticeSaveModel getUserInfo]mobile] length] > 7) {
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/third/%ld",[[NoticeSaveModel getUserInfo]user_id],(long)(tag+1)] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    self.numbers--;
                    [self request];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
            return;
        }
        if (self.numbers>=2) {
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/third/%ld",[[NoticeSaveModel getUserInfo]user_id],(long)(tag+1)] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    self.numbers--;
                    [self request];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"accunt.needknow"] message:nil cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
            [alerView showXLAlertView];
        }

    
    }else{
        if ([self.switchValueArr[tag] integerValue]) {
            [self.tableView reloadData];
            return;
        }
        if (tag == 3) {
            if (@available(iOS 13.0, *)){
                [self signInWithApple];
            }
            
            return;
        }
        [ShareSDK getUserInfo:tag == 0? SSDKPlatformTypeWechat : (tag == 1 ? SSDKPlatformTypeQQ : SSDKPlatformTypeSinaWeibo)
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             [self.tableView reloadData];
            [ShareSDK cancelAuthorize:tag == 0? SSDKPlatformTypeWechat : (tag == 1 ? SSDKPlatformTypeQQ : SSDKPlatformTypeSinaWeibo) result:^(NSError *error) {
                
            }];
             if (state == SSDKResponseStateSuccess)
             {
                 if (!user.credential) {
                     return;
                 }
                 if (tag == 0) {
                     user.uid = [NSString stringWithFormat:@"%@",user.rawData[@"openid"]];
                 }
                 [self logiWithThird:user type:[NSString stringWithFormat:@"%ld",(long)(tag+1)]];
                 DRLog(@"unionid=%@(openId=%@)",user.credential.uid,user.uid);
                 DRLog(@"%@",user.credential);
                 DRLog(@"token=%@",user.credential.token);
                 DRLog(@"nickname=%@",user.nickname);
             }
             else
             {
                 DRLog(@"%@",error);
             }
         }];
    }
}

#pragma mark- 点击登录
-(void)signInWithApple API_AVAILABLE(ios(13.0))
{
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest * request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    
    ASAuthorizationController *vc= [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    vc.delegate = self;
    vc.presentationContextProvider = self;
    
    [vc performRequests];
}

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
API_AVAILABLE(ios(13.0)){
   return  self.view.window;
}

#pragma mark- 授权成功的回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential*)authorization.credential;
        NSString * userID = credential.user;
        SSDKUser *appRegM = [[SSDKUser alloc] init];
        appRegM.uid = userID;
        appRegM.gender = 0;
        [self logiWithThird:appRegM type:@"4"];
    }
}
 
#pragma mark- 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)){
    NSString * errorMsg = nil;
    switch (error.code) {
            case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
            case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
            case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
            case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
            case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    [self showToastWithText:errorMsg];
}

- (void)logiWithThird:(SSDKUser *)user type:(NSString *)type{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:user.uid forKey:@"openId"];
    [parm setObject:[NSString stringWithFormat:@"%ld",(long)user.gender] forKey:@"userGender"];
    if (user.credential.uid) {
       [parm setObject:user.credential.uid?user.credential.uid:@"" forKey:@"unionId"];
    }
    if (user.nickname) {
        [parm setObject:user.nickname?user.nickname:@"" forKey:@"nickName"];
    }
    if (user.icon) {
        [parm setObject:user.icon?user.icon:@"" forKey:@"avatarUrl"];
    }
    
    [parm setObject:type forKey:@"authType"];
    [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [parm setObject:@"2" forKey:@"platformId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/third",[[NoticeSaveModel getUserInfo]user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
          [self request];
        }else{
            [self hideHUD];
        }
    } fail:^(NSError *error) {
        [self showToastWithText:error.description];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        NoticeHasLinkPhoneController *ctl = [[NoticeHasLinkPhoneController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }

    if (indexPath.section == 2) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"accunt.tosat3"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] cancleBtn:[NoticeTools getLocalStrWith:@"accunt.surezx"] right:YES];

        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                NoticeDesTroyView *view = [[NoticeDesTroyView alloc] initWithShowDestroy];
                view.sureDestroy = ^(BOOL sure) {
                    [weakSelf showHUD];
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"logout" Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        [weakSelf hideHUD];
                        if (success) {
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults removeObjectForKey:@"logininfo"];
                            [NoticeSaveModel outLoginClearData];
                            [(AppDelegate *)[UIApplication sharedApplication].delegate deleteAlias];

                            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            [appdel.socketManager.timer invalidate];
                            [appdel.socketManager.webSocket close];
                            appdel.socketManager = nil;
                            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATIONNEEDACTION" object:nil];
                        }
                    } fail:^(NSError * _Nullable error) {
                        [weakSelf hideHUD];
                    }];
                };
                [view showDestroyView];
            }
        };
        [alerView showXLAlertView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.titleL.text = @"手机号";
        cell.subL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        cell.subL.text = [[[NoticeSaveModel getUserInfo] mobile] length] > 6 ? [[NoticeSaveModel getUserInfo] mobile] : @"";
        [cell.backView setAllCorner:8];
        return cell;
    }else if(indexPath.section == 1){
 
        SXTitleAndSwitchCell *cell1 =  [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (self.switchValueArr.count) {
            cell1.switchButton.on = [self.switchValueArr[indexPath.row] integerValue];
            if ([self.switchValueArr[indexPath.row] integerValue]) {
                cell1.mainL.text = self.oswitchArr[indexPath.row];
            }else{
                cell1.mainL.attributedText = self.switchArr[indexPath.row];
            }
        }
        [cell1.backView setCornerOnTop:0];
        [cell1.backView setCornerOnBottom:0];
        if (indexPath.row == 0) {
            [cell1.backView setCornerOnTop:8];
        }
        if (@available(iOS 13.0, *)) {
            if (indexPath.row == 3) {
                [cell1.backView setCornerOnBottom:8];
            }
        }else{
            if (indexPath.row == 2) {
                [cell1.backView setCornerOnBottom:8];
            }
        }
        cell1.delegate = self;
        cell1.choiceTag = indexPath.row;
        return cell1;
    }else{
        SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.titleL.text = @"注销帐号";
        [cell.backView setAllCorner:8];
        return cell;
    }
  

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (@available(iOS 13.0, *)) {
            return 4;
        }
        return 3;
    }

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,section == 2 ? 8: 40)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,300, 40)];
        label.text = [NoticeTools getLocalStrWith:@"accunt.third"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [view addSubview:label];
    }
   
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (section == 2) {
        return 15;
    }
    return 40;
}
@end
