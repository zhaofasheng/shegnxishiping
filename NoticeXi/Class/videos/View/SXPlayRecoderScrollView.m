//
//  SXPlayRecoderScrollView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/24.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayRecoderScrollView.h"
#import "SXPlayRecoderScrollCell.h"
#import "SXPlayFullListController.h"
#import "SXPayVideoPlayDetailBaseController.h"
@implementation SXPlayRecoderScrollView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.payView = [[UIView alloc] initWithFrame:CGRectMake(20,0, frame.size.width-40, 140)];
        [self addSubview:self.payView];
        [self.payView setCornerOnBottom:10];
        self.payView.backgroundColor = [UIColor whiteColor];

        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(15,0,DR_SCREEN_WIDTH-40-30, 121);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.payView.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[SXPlayRecoderScrollCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 90;
        [self.payView addSubview:self.movieTableView];
        
   
    }
    return self;
}


- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.movieTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideosModel *model = self.dataArr[indexPath.row];
    if (model.searModel) {
        [self requestSearise:model.searModel.seriesId videoId:model.vid];
        return;
    }
    
    [self pushVideoDetail:model.vid];
}

- (void)requestSearise:(NSString *)searisId videoId:(NSString *)videoId{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",searisId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
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
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)getVideosSearise:(SXPayForVideoModel *)searModel videoId:(NSString *)videoId{
    
    
    NSString *url = @"";
    
    [[NoticeTools getTopViewController] showHUD];
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
                                                                                               view:[NoticeTools getTopViewController].navigationController.view];
                        [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
                        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
                        break;
                    }
                }
            }
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
  
}

- (void)refreshModelTime:(SXSearisVideoListModel *)model{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:model.schedule?model.schedule:@"0" forKey:@"schedule"];
    [parm setObject:model.is_finished?model.is_finished:@"0" forKey:@"isFinished"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/play/%@",model.videoId] Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
  
        }
    } fail:^(NSError * _Nullable error) {
        
    }];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXPlayRecoderScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.videoModel = self.dataArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
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
