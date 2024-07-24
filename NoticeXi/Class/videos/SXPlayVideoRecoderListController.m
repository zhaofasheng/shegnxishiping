//
//  SXPlayVideoRecoderListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/24.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayVideoRecoderListController.h"
#import "SXPlayRecoderListCell.h"
#import "SXPayVideoPlayDetailBaseController.h"
#import "SXPlayFullListController.h"
@interface SXPlayVideoRecoderListController ()
@property (nonatomic, assign) BOOL needReresh;
@property (nonatomic, strong) SXVideosModel *pushVideoModel;
@end

@implementation SXPlayVideoRecoderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    self.navBarView.hidden = YES;
    
    [self.tableView registerClass:[SXPlayRecoderListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 110;
    
    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlayTime) name:@"SXAPPREFRESHPLAYTIMENOTICE" object:nil];
}

- (void)refreshPlayTime{
    if (self.type != 1) {
        self.pageNo = 1;
        self.isDown = YES;
        [self request];
    }
}

- (void)createRefesh{
    
    __weak SXPlayVideoRecoderListController *ctl = self;

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
    
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"video/play/record?pageNo=%ld&queryType=%ld",self.pageNo,self.type];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                SXVideosModel *model = [SXVideosModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
         
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                
                self.tableView.tableFooterView = self.defaultL;
                self.marksL.text = @"去看看感兴趣的视频吧";
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXPlayRecoderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.videoModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideosModel *model = self.dataArr[indexPath.row];
    if (model.searModel) {
        [self requestSearise:model.searModel.seriesId videoId:model.vid];
        return;
    }
    
    [self.dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    [self.tableView reloadData];
    self.pushVideoModel = model;
    [self pushVideoDetail:model.vid];
}

- (void)requestSearise:(NSString *)searisId videoId:(NSString *)videoId{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",searisId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!searismodel) {
                return;
            }
            [self getVideosSearise:searismodel videoId:videoId];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)getVideosSearise:(SXPayForVideoModel *)searModel videoId:(NSString *)videoId{
    
    
    NSString *url = @"";
    
    [self showHUD];
    url = [NSString stringWithFormat:@"series/%@/video",searModel.seriesId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
      
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            NSMutableArray *videoList = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dict[@"data"]) {
                SXSearisVideoListModel *model = [SXSearisVideoListModel mj_objectWithKeyValues:dic];
                if (model.screen.intValue == 2) {
                    model.screen = @"1";
                }
                [videoList addObject:model];
            }
            
            if (videoList.count) {
                for (SXSearisVideoListModel *video in videoList) {
                    if ([video.videoId isEqualToString:videoId]) {
                        SXPayVideoPlayDetailBaseController *ctl = [[SXPayVideoPlayDetailBaseController alloc] init];
                        ctl.paySearModel = searModel;
                        ctl.searisArr = videoList;
                        ctl.currentPlayModel = video;
                        __weak typeof(self) weakSelf = self;
                        ctl.refreshPlayTimeBlock = ^(SXSearisVideoListModel * _Nonnull currentModel) {
                            [weakSelf refreshModelTime:currentModel];
                        };
                        
                        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                                        withSubType:kCATransitionFromLeft
                                                                                           duration:0.3f
                                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                                               view:self.navigationController.view];
                        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
                        [self.navigationController pushViewController:ctl animated:NO];
                        break;
                    }
                }
            }
        }
        [self hideHUD];
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
  
}

- (void)refreshModelTime:(SXSearisVideoListModel *)model{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:model.schedule?model.schedule:@"0" forKey:@"schedule"];
    [parm setObject:model.is_finished?model.is_finished:@"0" forKey:@"isFinished"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/play/%@",model.videoId] Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SXAPPREFRESHPLAYTIMENOTICE" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];

}

- (void)pushVideoDetail:(NSString *)videoId{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/appletDetail/%@",videoId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dict[@"data"]];
            if (!videoM) {
                return;
            }
       
            videoM.textContent = [NSString stringWithFormat:@"%@\n%@",videoM.title,videoM.introduce];
            SXPlayFullListController *ctl = [[SXPlayFullListController alloc] init];
            __weak typeof(self) weakSelf = self;
            ctl.seekTimeBlock = ^(NSString * _Nonnull schele, NSString * _Nonnull isFinish) {
                weakSelf.pushVideoModel.schedule = schele;
                weakSelf.pushVideoModel.is_finished = isFinish;
                [weakSelf.tableView reloadData];
            };
            ctl.modelArray = [NSMutableArray arrayWithArray:@[videoM]];
            ctl.currentPlayIndex = 0;
            ctl.noRequest = YES;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            
        }
        
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

@end
