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
    }else if(section == 1){
        str = @"关闭后，手机将不再接收新的系统消息通知";
    }else if(section == 2){

        str = @"关闭后，手机将不再接收视频评论消息通知";
        if (tag == 1) {
            str = @"关闭后，手机将不再接收视频评论的点赞消息通知";
        }else if (tag == 2){
            str = @"关闭后，手机将不再接收店铺留言的消息通知";
        }
    }else if(section == 3){
        if (tag == 0) {
            str = @"关闭后，购买课程内容更新时不再接受推送提醒";
        }else if (tag == 1){
            str = @"关闭后，课程评论和回复不再接受推送提醒";
        }else if (tag == 2){
            str = @"关闭后，课程评论和回复的点赞消息不再接受推送提醒";
        }
        
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
    }else if (section == 3){
        if (tag == 0) {
            [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"seriesRemind"];
        }else if (tag == 1){
            [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"seriesCommentRemind"];
        }else{
            [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"seriesZanRemind"];
        }
        
    }else if (section == 2){
        if (tag == 0) {
            [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"commentRemind"];
        }else if(tag == 1){
            [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"likeRemind"];
        }else{
            [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"orderCommentRemind"];
        }
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
    [cell.backView setAllCorner:0];
    cell.choiceTag = indexPath.row;
    cell.choiceSection = indexPath.section;
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell.backView setAllCorner:8];
        cell.mainL.text = @"私信通知";
        cell.switchButton.on = self.noticeM.chat_pri_remind.boolValue;
    }
    else if (indexPath.section == 1){
        [cell.backView setAllCorner:8];
        cell.switchButton.on = self.noticeM.sys_remind.boolValue;
        cell.mainL.text = @"系统消息通知";
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:8];
            cell.mainL.text = @"评论消息";
            cell.switchButton.on = self.noticeM.comment_remind.boolValue;
        }else if (indexPath.row == 1){
            cell.mainL.text = @"点赞消息";
            cell.switchButton.on = self.noticeM.like_remind.boolValue;
        }else if (indexPath.row == 2){
            [cell.backView setCornerOnBottom:8];
            cell.mainL.text = @"店铺留言消息";
            cell.switchButton.on = self.noticeM.order_comment.boolValue;
        }
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:8];
            cell.switchButton.on = self.noticeM.series_remind.boolValue;
            cell.mainL.text = @"购买课程内容有更新";
        }else if (indexPath.row == 1){
            cell.switchButton.on = self.noticeM.series_comment_remind.boolValue;
            cell.mainL.text = @"课程评论消息";
        }else if (indexPath.row == 2){
            cell.switchButton.on = self.noticeM.series_zan_remind.boolValue;
            cell.mainL.text = @"课程点赞消息";
            [cell.backView setCornerOnBottom:8];
        }
       
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 3;
    }
    if(section == 3){
        return 3;
    }
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
