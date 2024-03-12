//
//  NoticeEditViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditViewController.h"
#import "NoticeChangeIconViewController.h"
#import "NoticeChangeNameViewController.h"
#import "NoticeChangeIntroduceViewController.h"
#import "NoticeManagerController.h"
#import "NoticeManager.h"
#import "SXSetCell.h"
@interface NoticeEditViewController ()<NoticeManagerUserDelegate>

@property (nonatomic, strong) NSArray *cellTitleArr;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation NoticeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"set.cell1"];
    
    self.cellTitleArr = @[@"用户名",@"声昔学号",@"文字简介"];
    [self.tableView registerClass:[SXSetCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 52;
    
 
    if ([NoticeTools isManager]) {
     
        [self.navBarView.rightButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
        self.navBarView.rightButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [self.navBarView.rightButton addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
      
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 270)];
    headerView.backgroundColor = self.view.backgroundColor;
    headerView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = headerView;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, DR_SCREEN_WIDTH-40, 240)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [backView setCornerOnTop:20];
    [headerView addSubview:backView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-40-120)/2, 60, 120, 120)];
    [self.iconImageView setAllCorner:60];
    [backView addSubview:self.iconImageView];
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [self.iconImageView addGestureRecognizer:taps];
    
    UIImageView *imageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)-32,CGRectGetMaxY(self.iconImageView.frame)-32, 32, 32)];
    imageView.userInteractionEnabled = YES;
    imageView.image = UIImageNamed(@"changeshoproleimg");
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [imageView addGestureRecognizer:tap2];
    [backView addSubview:imageView];
}


- (void)managerClick{
    
    self.magager.type = @"管理员登陆";
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeManagerController *ctl = [[NoticeManagerController alloc] init];
            ctl.mangagerCode = code;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)iconTap{
    NoticeChangeIconViewController *ctl = [[NoticeChangeIconViewController alloc] init];

    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeChangeNameViewController *ctl = [[NoticeChangeNameViewController alloc] init];
        ctl.name = self.userInfo.nick_name;
        [self.navigationController pushViewController:ctl animated:YES];

    }else if (indexPath.row == 1){
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        [pastboard setString:self.userInfo.frequency_no];
        [self showToastWithText:@"学号已复制"];
    }else if (indexPath.row == 2){
        NoticeChangeIntroduceViewController *ctl = [[NoticeChangeIntroduceViewController alloc] init];
        ctl.induce = self.userInfo.self_intro;
        [self.navigationController pushViewController:ctl animated:YES];

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setCornerOnBottom:0];
    if (indexPath.row == 2) {
        [cell setCornerOnBottom:20];
    }
    cell.titleL.text = self.cellTitleArr[indexPath.row];
    cell.subImageV.image = UIImageNamed(@"cellnextbutton");
    cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    if (indexPath.row == 0) {
        cell.subL.text = self.userInfo.nick_name;
    }else if (indexPath.row == 1){
        cell.subImageV.image = UIImageNamed(@"Image_fuxuehao");
        cell.subL.text = self.userInfo.frequency_no;
    }else if (indexPath.row == 2){
        if (!self.userInfo.self_intro.length) {
            cell.subL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            cell.subL.text = @"还没有填写简介";
        }else{
            cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            cell.subL.text =  self.userInfo.self_intro;
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleArr.count;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.userInfo = [NoticeSaveModel getUserInfo];

    [self.tableView reloadData];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.userInfo = userIn;
            [NoticeSaveModel saveUserInfo:userIn];
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageAvoidDecodeImage];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}
@end
