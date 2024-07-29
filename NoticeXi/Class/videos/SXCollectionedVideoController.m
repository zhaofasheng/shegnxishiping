//
//  SXCollectionedVideoController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXCollectionedVideoController.h"
#import "SXScVideoAlbumCell.h"
#import "SXAddVideoZjView.h"
#import "SXVideosForAlbumController.h"
@interface SXCollectionedVideoController ()

@end

@implementation SXCollectionedVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.titleL.text = @"收藏的视频";
    
    [self.tableView registerClass:[SXScVideoAlbumCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 110;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    UIView *addView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];
    
    UIButton *addBtn = [[UIButton  alloc] initWithFrame:CGRectMake(20, 5, DR_SCREEN_WIDTH-40, 40)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [addBtn setAllCorner:20];
    [addBtn setTitle:@"新建专辑" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addBtn];
    
    [self createRefesh];
    
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
}


- (void)createRefesh{
    
    __weak SXCollectionedVideoController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl request];
    }];
}

- (void)request{
    
    NSString *url = [NSString stringWithFormat:@"videoAblum/get?pageNo=%ld",self.pageNo];

    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept: @"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideoZjModel *model = [SXVideoZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            self.tableView.tableFooterView = self.dataArr.count?nil:self.defaultL;
            self.marksL.text = @"快去收藏感兴趣的视频吧";
            [self.tableView reloadData];
         
            
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoZjModel *model = self.dataArr[indexPath.row];

    SXVideosForAlbumController *ctl = [[SXVideosForAlbumController alloc] init];
    ctl.zjModel = model;
    __weak typeof(self) weakSelf = self;
    ctl.nameChangeBlock = ^(BOOL change) {
        [weakSelf.tableView reloadData];
    };
    ctl.deletezjBlock = ^(SXVideoZjModel * _Nonnull model) {
        for (SXVideoZjModel *oldmodel in weakSelf.dataArr) {
            if ([model.albumId isEqualToString:oldmodel.albumId]) {
                [weakSelf.dataArr removeObject:oldmodel];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)addClick{
    SXAddVideoZjView *addView = [[SXAddVideoZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    __weak typeof(self) weakSelf = self;
    addView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
      
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:name forKey:@"ablumName"];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"videoAblum/create" Accept: @"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                SXVideoZjModel *model = [SXVideoZjModel mj_objectWithKeyValues:dict[@"data"]];
                model.ablum_name = name;
                model.video_num = @"0";
                if (model){
                    [weakSelf.dataArr insertObject:model atIndex:0];
                    [weakSelf.tableView reloadData];
                    weakSelf.tableView.tableFooterView = nil;
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        } fail:^(NSError * _Nullable error) {
        }];
    };
    [addView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXScVideoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.zjModel = self.dataArr[indexPath.row];
    return cell;
}
@end
