//
//  NoticeSysViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSysViewController.h"
#import "NoticeSysCell.h"
#import "NoticeNoDataView.h"
#import "AFHTTPSessionManager.h"
#import "NoticeWebViewController.h"
#import "NoticeSysMeassageTostView.h"
@interface NoticeSysViewController ()

@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeSysMeassageTostView *tostView;
@property (nonatomic, strong) NSString *topName;
@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic, strong) NSString *messageId;
@end

@implementation NoticeSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.navBarView.titleL.text = @"系统消息";
    [self.tableView registerClass:[NoticeSysCell class] forCellReuseIdentifier:@"cell1"];

    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    

    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.footView =  [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMessage *message = self.dataArr[indexPath.row];
    self.messageId = message.msgId;
    ////1 图书，2播客,3话题，4活动，5声昔君说，6反馈，7版本更新
   if (message.category_id.intValue == 4){
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = message.supply;
        ctl.isFromShare = YES;
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:self.navigationController.view];
        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [self.navigationController pushViewController:ctl animated:NO];
    }else if (message.category_id.intValue == 5){
        self.tostView.message = message;
        [self.tostView showActiveView];
    }else if (message.category_id.intValue == 7){
        NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
        [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *results = responseObject[@"results"];
            if (results && results.count > 0) {
                NSDictionary *response = results.firstObject;
                NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
                if (trackViewUrl) {
                    NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMessage *model = self.dataArr[indexPath.row];
    return 44*2+20+45+model.contentHeight+15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.message = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
    
    __weak NoticeSysViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/1?lastId=%@",[[NoticeSaveModel getUserInfo]user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
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
                NoticeMessage *model = [NoticeMessage mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeMessage *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.msgId;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
    }];
}

- (NoticeSysMeassageTostView *)tostView{
    if (!_tostView) {
        _tostView = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _tostView;
}

@end
