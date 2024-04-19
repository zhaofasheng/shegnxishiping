//
//  SXSettingController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSettingController.h"
#import "SXSetCell.h"
#import "SXTitleAndSwitchCell.h"
#import "NoticeEditViewController.h"
#import "AppDelegate+Notification.h"
#import "NoticeCountSafeViewController.h"
#import "NoticeNewMarkViewController.h"
#import "NoticeVersionController.h"
#import "NoticeFAQViewController.h"
#import "SXHisToryDownLoadController.h"
#import "ZFSDateFormatUtil.h"
#import "KTVHTTPCache.h"
@interface SXSettingController ()<SXSwitchChoiceDelegate>

@property (nonatomic, strong) NSArray *section0titleArr;

@property (nonatomic, strong) NSArray *section1titleArr;

@property (nonatomic, strong) NSArray *section2titleArr;

@end

@implementation SXSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"设置";

    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    [self.tableView registerClass:[SXSetCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SXTitleAndSwitchCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.rowHeight = 52;
    
    self.section0titleArr = @[@"个人资料",@"帐号安全",@"消息通知"];
    self.section1titleArr = @[@"版本更新",@"关于声昔"];
    self.section2titleArr = @[@"历史数据下载",@"申请退款"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35,CGRectGetMaxY(self.tableView.frame),DR_SCREEN_WIDTH-70, 50);
    [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    btn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    btn.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    [btn setAllCorner:25];
    [btn addTarget:self action:@selector(outLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn setTitle:@"退出帐号" forState:UIControlStateNormal];//
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NoticeEditViewController *ctl = [[NoticeEditViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        if (indexPath.row == 1) {
            //
            NoticeCountSafeViewController *ctl = [[NoticeCountSafeViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        if (indexPath.row == 2) {
            NoticeNewMarkViewController *ctl = [[NoticeNewMarkViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NoticeVersionController *ctl = [[NoticeVersionController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        if (indexPath.row == 1) {
            NoticeFAQViewController *ctl = [[NoticeFAQViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
    if (indexPath.section == 3) {
        SXHisToryDownLoadController *ctl = [[SXHisToryDownLoadController alloc] init];
        ctl.isTuikuan = indexPath.row == 0?NO:YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        [KTVHTTPCache cacheDeleteAllCaches];
        [self.tableView reloadData];
    }
}

- (void)outLoginClick{
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"logininfo"];
            [weakSelf outLogin];
        }else if(buttonIndex == 1){
            [weakSelf outLogin];
        }
    } otherButtonTitleArray:@[@"仅退出登录",@"清空登录痕迹并退出"]];
    [sheet show];
}

- (void)outLogin{
    if (self.needFirstBlock) {
        self.needFirstBlock(YES);
    }
    [(AppDelegate *)[UIApplication sharedApplication].delegate deleteAlias];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager.timer invalidate];
    [appdel.socketManager.webSocket close];
    appdel.socketManager = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    [NoticeSaveModel outLoginClearData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.section0titleArr.count;
    }else if (section == 1){
        return self.section1titleArr.count;
    }else if (section == 2){
        return 2;
    }
    return self.section2titleArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if (currentTime > [ZFSDateFormatUtil timeIntervalWithDateString:@"2024-05-01 00:00:00"]) {
        return 3;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        SXTitleAndSwitchCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell1.delegate = self;
        cell1.mainL.text = @"是否允许流量下载";
        [cell1.backView setCornerOnTop:10];
        cell1.switchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:HWDownloadAllowsCellularAccessKey];
        return cell1;
    }
    SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.subL.text = @"";
    cell.subImageV.hidden = NO;
    [cell.backView setCornerOnTop:0];
    [cell.backView setCornerOnBottom:0];
    if (indexPath.section == 0) {
        cell.titleL.text = self.section0titleArr[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:10];
        }else if(indexPath.row == self.section0titleArr.count-1){
            [cell.backView setCornerOnBottom:10];
        }
    }else if(indexPath.section == 1){
        cell.titleL.text = self.section1titleArr[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:10];
        }else if(indexPath.row == self.section1titleArr.count-1){
            [cell.backView setCornerOnBottom:10];
        }
    }else if(indexPath.section == 2 && indexPath.row == 1){
        cell.titleL.text = @"清除系统缓存";
        cell.subImageV.hidden = YES;
        [cell.backView setCornerOnBottom:10];
        cell.subL.text = [HWToolBox stringFromByteCount:[KTVHTTPCache cacheTotalCacheLength]];
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-40-15-cell.subL.frame.size.width, 0, cell.subL.frame.size.width, cell.subL.frame.size.height);
    }
    else{
        cell.titleL.text = self.section2titleArr[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:10];
        }else if(indexPath.row == self.section2titleArr.count-1){
            [cell.backView setCornerOnBottom:10];
        }
    }
    return cell;
}

#pragma SwitchChoiceDelegate
- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{

    if (isOn) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:HWDownloadAllowsCellularAccessKey];
        [self showToastWithText:@"已开启蜂窝网络下载"];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:HWDownloadAllowsCellularAccessKey];
        [self showToastWithText:@"已关闭蜂窝网络下载"];
    }
    
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:HWDownloadAllowsCellularAccessChangeNotification object:nil];
    [self.tableView reloadData];
  
}


@end
