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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideosForAlbumController *ctl = [[SXVideosForAlbumController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)addClick{
    SXAddVideoZjView *addView = [[SXAddVideoZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];

    addView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
      
//        NSMutableDictionary *parm = [NSMutableDictionary new];
//
//        if (self.isLimt) {
//            [parm setObject:@"0" forKey:@"bucketId"];
//            [parm setObject:@"0000000000" forKey:@"albumCoverUri"];
//            [parm setObject:name forKey:@"albumName"];
//        }else{
//            [parm setObject:name forKey:@"albumName"];
//            [parm setObject:isOpen?@"1":@"3" forKey:@"albumType"];
//        }
//
//        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isLimt?@"dialogAlbums": [NSString stringWithFormat:@"user/%@/voiceAlbum",[NoticeTools getuserId]] Accept:self.isLimt?@"application/vnd.shengxi.v4.7.6+json": @"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
//            if (success) {
//                [self.collectionView.mj_header beginRefreshing];
//            }
//
//            [self hideHUD];
//        } fail:^(NSError * _Nullable error) {
//            [self hideHUD];
//        }];
    };
    [addView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXScVideoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}
@end
