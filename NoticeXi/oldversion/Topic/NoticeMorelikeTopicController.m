//
//  NoticeMorelikeTopicController.m
//  NoticeXi
//
//  Created by li lei on 2023/7/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMorelikeTopicController.h"
#import "NoticeLocalTopicCell.h"
#import "NoticeTopiceVoicesListViewController.h"
@interface NoticeMorelikeTopicController ()

@end

@implementation NoticeMorelikeTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.hidden = NO;
    self.navBarView.titleL.text = [NoticeTools chinese:@"我收藏的" english:@"My" japan:@"私の"];
    [self.tableView registerClass:[NoticeLocalTopicCell class] forCellReuseIdentifier:@"locallCell"];
    self.dataArr = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = 44;
    [self requestLike];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeLocalTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locallCell"];
    cell.type = 2;
    cell.topicM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.cancelBlock = ^(NoticeTopicModel * _Nonnull topicM) {
        if (weakSelf.topicBlock) {
            weakSelf.topicBlock(topicM);
        }
    };
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeTopicModel *model = self.dataArr[indexPath.row];
    if (self.isSearch) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.topicChoiceBlock) {
            self.topicChoiceBlock(self.dataArr[indexPath.row]);
        }
        return;
    }
    NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
    ctl.topicId = model.topic_id;
    ctl.topicName = model.topic_name;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)requestLike{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topicCollection?type=0" Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeTopicModel *topicM = [NoticeTopicModel mj_objectWithKeyValues:dic];
                topicM.isCollection = YES;
                [self.dataArr addObject:topicM];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

@end
