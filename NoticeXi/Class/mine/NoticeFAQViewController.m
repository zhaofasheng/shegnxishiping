//
//  NoticeFAQViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFAQViewController.h"
#import "NoticeWebViewController.h"
#import "AFHTTPSessionManager.h"
#import "SXSetCell.h"
#import "NoticeXieYiViewController.h"
#import "SXWebViewController.h"
@interface NoticeFAQViewController ()

@end

@implementation NoticeFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 52;
    self.navBarView.titleL.text = @"关于声昔";
    [self.tableView registerClass:[SXSetCell class] forCellReuseIdentifier:@"cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeXieYiViewController * webctl = [[NoticeXieYiViewController alloc] init];
        [self.navigationController pushViewController:webctl animated:YES];
        return;
    }
    if (indexPath.row == 1) {
        SXWebViewController * webctl = [[SXWebViewController alloc] init];
        webctl.url = @"http://priapi.byebyetext.com/privacy.html";
        [self.navigationController pushViewController:webctl animated:YES];
        return;
    }
    if (indexPath.row == 2) {
        NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1358222995&pageNumber=0&sortOrdering=2&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.backView setCornerOnTop:0];
    [cell.backView setCornerOnBottom:0];
    

    if (indexPath.row == 0) {
        [cell.backView setCornerOnTop:8];
        cell.titleL.text = @"用户协议";
    }
    else if(indexPath.row == 1){
        cell.titleL.text = @"隐私政策";
    }else{
        [cell.backView setCornerOnBottom:8];
        cell.titleL.text = @"去评分";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

@end
