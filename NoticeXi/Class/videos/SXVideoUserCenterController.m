//
//  SXVideoUserCenterController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoUserCenterController.h"
#import "SXVideoUserCenterView.h"
#import "SXWebViewController.h"
#import "SXUserCenterCell.h"
@interface SXVideoUserCenterController ()
@property (nonatomic, strong) SXVideoUserCenterView *headerView;
@property (nonatomic, strong) NSArray *section0imgArr;
@property (nonatomic, strong) NSArray *section0titleArr;
@property (nonatomic, strong) NSArray *urlArr;
@end

@implementation SXVideoUserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.section0titleArr = @[@"抖音",@"小红书",@"哔哩哔哩",@"快手"];
    self.section0imgArr = @[@"Image_douyin",@"Image_xiaohongshu",@"Image_bilibili",@"Image_kuaishou"];
    self.urlArr = @[@"https://www.douyin.com/user/MS4wLjABAAAAGdKxVMSPEHPVwLwbiTf6MAtKI716iGmXuuZn7Wej4Dc",@"https://www.xiaohongshu.com/user/profile/5ecb412e00000000010038d3",@"https://space.bilibili.com/1426112202?spm_id_from=333.337.0.0",@"https://www.kuaishou.com/profile/3x2i5xvr6dud6w6"];
    
    self.tableView.rowHeight = 64;
    [self.tableView registerClass:[SXUserCenterCell class] forCellReuseIdentifier:@"cell"];
    
    self.headerView = [[SXVideoUserCenterView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 262)];
    self.tableView.tableHeaderView = self.headerView;
    [self requestUser];
    
    UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-72-15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2,72, 32)];
    [button setAllCorner:16];
    button.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    [button setTitle:@"联系客服" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = TWOTEXTFONTSIZE;
    [button addTarget:self action:@selector(xiaoerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:button];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        NSURL *url = [NSURL URLWithString:@"snssdk1128://user/profile/835266208345102"];
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            return;
        }
    }else if (indexPath.row == 3){
        NSURL *url = [NSURL URLWithString:@"kwai://work"];
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"打开快手后搜索【东北李老师】" cancleBtn:@"好的"];
            alerView.resultIndex = ^(NSInteger index) {
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            };
            [alerView showXLAlertView];
            return;
        }
    }
    SXWebViewController * webctl = [[SXWebViewController alloc] init];
    webctl.url = self.urlArr[indexPath.row];
    [self.navigationController pushViewController:webctl animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.section0imgArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXUserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleImageView.image = UIImageNamed(self.section0imgArr[indexPath.row]);
    cell.titleL.text = self.section0titleArr[indexPath.row];
    if (indexPath.row == 0) {
        [cell.backView setCornerOnTop:10];
    }else if(indexPath.row == self.section0imgArr.count-1){
        [cell.backView setCornerOnBottom:10];
    }
    return cell;
}


- (void)xiaoerClick{
    [NoticeComTools connectXiaoer];
}

- (void)requestUser{
    NSString *url = [NSString stringWithFormat:@"video/user/%@",self.userModel.userId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.headerView.userModel = [SXUserModel mj_objectWithKeyValues:dict[@"data"]];
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {

    }];
}


@end
