//
//  NoticeGetVipRecoderController.m
//  NoticeXi
//
//  Created by li lei on 2023/9/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeGetVipRecoderController.h"
#import "NoticeVipGetStoryCell.h"
@interface NoticeGetVipRecoderController ()

@end

@implementation NoticeGetVipRecoderController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools chinese:@"福利领取记录" english:@"Records" japan:@"受け取った記録"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.rowHeight = 92+15;
    [self.tableView registerClass:[NoticeVipGetStoryCell class] forCellReuseIdentifier:@"cell"];
    [self request];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVipGetStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.vipModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)request{
    self.dataArr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"userContributeCard/log" Accept:@"application/vnd.shengxi.v5.5.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
     
        if (success) {
          
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVipDataModel *model = [NoticeVipDataModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }

    } fail:^(NSError * _Nullable error) {
  
    }];
}
@end
