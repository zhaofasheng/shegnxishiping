//
//  SXUserHowController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserHowController.h"
#import "SXSetCell.h"
@interface SXUserHowController ()

@end

@implementation SXUserHowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 52;
    self.navBarView.titleL.text = @"声昔使用手册";
    [self.tableView registerClass:[SXSetCell class] forCellReuseIdentifier:@"cell"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.backView setCornerOnTop:0];
    [cell.backView setCornerOnBottom:0];
    

    if (indexPath.row == 0) {
        [cell.backView setCornerOnTop:8];
        cell.titleL.text = @"咨询模块咋玩？";
    }else{
        [cell.backView setCornerOnBottom:8];
        cell.titleL.text = @"声昔使用手册";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

@end
