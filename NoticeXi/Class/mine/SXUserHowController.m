//
//  SXUserHowController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserHowController.h"
#import "SXSetCell.h"
#import "NoticeShopRuleController.h"
#import "NoticeOpenTbModel.h"

@interface SXUserHowController ()

@end

@implementation SXUserHowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 52;
    self.navBarView.titleL.text = @"声昔使用手册";
    [self.tableView registerClass:[SXSetCell class] forCellReuseIdentifier:@"cell"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"taskGuide" Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeOpenTbModel *model = [NoticeOpenTbModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeOpenTbModel *model = self.dataArr[indexPath.row];
    NoticeShopRuleController *ctl = [[NoticeShopRuleController alloc] init];
    ctl.url = model.cover_url;
    ctl.navigationItem.title = model.title;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.backView setCornerOnTop:0];
    [cell.backView setCornerOnBottom:0];
    
    NoticeOpenTbModel *model = self.dataArr[indexPath.row];
    if (self.dataArr.count == 1) {
        [cell.backView setAllCorner:8];
    }else{
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:8];
        }
        if(indexPath.row == (self.dataArr.count-1)){
            [cell.backView setCornerOnBottom:8];
            
        }
    }

    cell.titleL.text = model.title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

@end
