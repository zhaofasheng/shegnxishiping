//
//  NoticeNewMarkViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewMarkViewController.h"
#import "SXTitleAndSwitchCell.h"
#import "NoticeNoticenterModel.h"
#import "NoticeChatStyleSetController.h"
@interface NoticeNewMarkViewController ()<SXSwitchChoiceDelegate>

@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, strong) NoticeAbout *aboutM;
@end

@implementation NoticeNewMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"push.title"];
    [self.tableView registerClass:[SXTitleAndSwitchCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.rowHeight = 52;
    [self requestData];
}

- (void)requestData{
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            [self.tableView reloadData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=notice",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.aboutM = [NoticeAbout new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                if ([setM.setting_name isEqualToString:@"about_artwork"]) {//灵魂画手
                    self.aboutM.about_artwork = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"resource_subscription"]){//书影音订阅开关
                    self.aboutM.resource_subscription = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"about_clock_vote"]){//闹钟配音开关
                    self.aboutM.about_clock_vote = setM.setting_value;
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

#pragma SwitchChoiceDelegate
- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{

    if (isOn) {
        [self changeWithSection:section tag:tag isOn:isOn];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *str = nil;
    if (section == 0) {
        str = @"关闭后，手机将不再接收新的私信通知";
      
    }else{
        str = @"关闭后，手机将不再接收新的系统消息通知";
    }
    
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.sureclose"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf changeWithSection:section tag:tag isOn:isOn];
        }else{
            [self.tableView reloadData];
        }
    };
    [alerView showXLAlertView];
}

- (void)changeWithSection:(NSInteger)section tag:(NSInteger)tag isOn:(BOOL)isOn{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (section == 0) {
        [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"chatPriRemind"];

    }else if (section == 1){
        [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"sysRemind"];
 
    }
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self requestData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXTitleAndSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    [cell.backView setAllCorner:8];
    cell.choiceTag = indexPath.row;
    cell.choiceSection = indexPath.section;
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.mainL.text = @"私信通知";
        cell.switchButton.on = self.noticeM.chat_pri_remind.boolValue;
    }
    else{
        cell.switchButton.on = self.noticeM.sys_remind.boolValue;
        cell.mainL.text = @"系统消息通知";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
   return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return [UIView new];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,DR_SCREEN_WIDTH-35, 45)];
    label.text = @"打开按钮可以避免错过重要的消息";
    label.font = TWOTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45;
    }
    return 8;
}


@end
