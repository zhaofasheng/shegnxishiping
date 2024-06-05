//
//  SXShopLyStoryController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLyStoryController.h"
#import "SXShopLyStoryCell.h"
@interface SXShopLyStoryController ()

@end

@implementation SXShopLyStoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"留言记录";
    
    [self.tableView registerClass:[SXShopLyStoryCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 117;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopLyStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;self.dataArr.count;
}
@end
