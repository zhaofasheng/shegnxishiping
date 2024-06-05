//
//  SXShopLyListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLyListController.h"
#import "SXShopsliuyanCell.h"
@interface SXShopLyListController ()

@end

@implementation SXShopLyListController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.tableView registerClass:[SXShopsliuyanCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 70;
    self.navBarView.titleL.text = @"店铺留言";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopsliuyanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}
@end
