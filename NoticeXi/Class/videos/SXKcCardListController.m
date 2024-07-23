//
//  SXKcCardListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcCardListController.h"
#import "SXKcCardDetailController.h"
#import "SXkcCardListCell.h"
@interface SXKcCardListController ()

@end

@implementation SXKcCardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    self.navBarView.hidden = YES;
    
    [self.tableView registerClass:[SXkcCardListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 143;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKcCardDetailController *ctl = [[SXKcCardDetailController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXkcCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

@end
