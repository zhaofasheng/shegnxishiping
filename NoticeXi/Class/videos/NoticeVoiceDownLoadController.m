//
//  NoticeVoiceDownLoadController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceDownLoadController.h"
#import "NoticeDownloadVoiceCell.h"
#import "SXPlaySaveVideoBaseController.h"
#import "SXDownVideoheaderView.h"
#import "SXPlayChcahVideoController.h"
@interface NoticeVoiceDownLoadController ()
@property (nonatomic, strong) NSMutableArray <HWDownloadModel *> *hasfinishArr;
@end

@implementation NoticeVoiceDownLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navBarView.titleL.text = @"缓存";
    self.navBarView.hidden = NO;
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeDownloadVoiceCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SXDownVideoheaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    self.tableView.rowHeight = 74;
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.hasfinishArr = [[NSMutableArray alloc] init];
    
    [self addNotification];
//    
//    [self.navBarView.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.navBarView.rightButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
//    [self.navBarView.rightButton setTitle:@"加缓存" forState:UIControlStateNormal];
//    [self.navBarView.rightButton addTarget:self action:@selector(addDown) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addNotification
{
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgress:) name:HWDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:HWDownloadStateChangeNotification object:nil];

}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
      //删除数据源
        if (indexPath.section == 1) {
            [[HWDownloadManager shareManager] deleteTaskAndCache:weakSelf.hasfinishArr[indexPath.row]];
            [weakSelf.hasfinishArr removeObjectAtIndex:indexPath.row];
        }else if (indexPath.section == 0){//取消下载
            [[HWDownloadManager shareManager] deleteTaskAndCache:weakSelf.dataArr[indexPath.row]];
            [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
        }
        [weakSelf.tableView reloadData];
        
        if (weakSelf.dataArr.count || weakSelf.hasfinishArr.count) {
            weakSelf.tableView.tableFooterView = nil;
        }else{
            weakSelf.tableView.tableFooterView = self.defaultL;
        }
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    Configuration.performsFirstActionWithFullSwipe = NO;
    return Configuration;
}

//加缓冲
- (void)addDown{
    // 模拟网络数据
    NSArray *testData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testData.plist" ofType:nil]];

    // 转模型
    NSMutableArray *arr = [HWDownloadModel mj_objectArrayWithKeyValuesArray:testData];
    NSArray *hasData = [[HWDataBaseManager shareManager] getAllCacheData];
    for (HWDownloadModel *newmodel in arr) {
        BOOL hasSave = NO;
        for (HWDownloadModel *hasDownM in hasData) {//去重，存在的就不要继续缓存
            if ([hasDownM.vid isEqualToString:newmodel.vid]) {
                hasSave = YES;
                break;
            }
        }
        if (!hasSave) {
            [self down:newmodel];
            break;
        }
    }
}

- (void)down:(HWDownloadModel *)downModel{
    [[HWDownloadManager shareManager] startDownloadTask:downModel];
    
    [self getNoFinishcachData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
    
    // 获取网络数据
   // [self getInfo];

    // 获取缓存
    [self getCacheData];
}

- (void)getInfo
{
    // 模拟网络数据
    NSArray *testData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testData.plist" ofType:nil]];

    // 转模型
    self.dataArr = [HWDownloadModel mj_objectArrayWithKeyValuesArray:testData];
}

- (void)getNoFinishcachData{
    // 获取没有缓存完成的数据
    NSArray *cacheData = [[HWDataBaseManager shareManager] getAllUnDownloadedData];
    [self.dataArr removeAllObjects];
    for (HWDownloadModel *model in cacheData) {
        [self.dataArr addObject:model];
    }
}

- (void)getCacheData
{
    [self getNoFinishcachData];

    
    //获取所有下载完成的数据
    [self.hasfinishArr removeAllObjects];
    for (HWDownloadModel *finishedmodel in [[HWDataBaseManager shareManager] getAllDownloadedData]) {
        [self.hasfinishArr addObject:finishedmodel];
    }

    if (self.dataArr.count || self.hasfinishArr.count) {
        self.tableView.tableFooterView = nil;
    }else{
        self.tableView.tableFooterView = self.defaultL;
    }
    [self.tableView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HWDownloadModel *model = self.dataArr[indexPath.row];
        if (model.state == HWDownloadStateFinish) {
            SXPlaySaveVideoBaseController *ctl = [[SXPlaySaveVideoBaseController alloc] init];
            ctl.downloadModel = model;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }else if (indexPath.section == 1){
        HWDownloadModel *model = self.hasfinishArr[indexPath.row];
        if (model.state == HWDownloadStateFinish) {
            SXPlaySaveVideoBaseController *ctl = [[SXPlaySaveVideoBaseController alloc] init];
            ctl.downloadModel = model;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dataArr.count) {
            return 40;
        }
        return 0;
    }
    if (self.hasfinishArr.count) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SXDownVideoheaderView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (section == 0) {
        headV.mainTitleLabel.text = [NSString stringWithFormat:@"缓存中(%ld)",self.dataArr.count];
    }else{
        headV.mainTitleLabel.text = [NSString stringWithFormat:@"已缓存(%ld)",self.hasfinishArr.count];
    }
 
    return headV;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.hasfinishArr.count;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDownloadVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.model = self.dataArr[indexPath.row];
    }else{
        cell.model = self.hasfinishArr[indexPath.row];
    }

    return cell;
}
#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downLoadProgress:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;

    [self.dataArr enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 主线程更新cell进度
            dispatch_async(dispatch_get_main_queue(), ^{
                NoticeDownloadVoiceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [cell updateViewWithModel:downloadModel];
            });
            
            *stop = YES;
        }
    }];
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    HWDownloadModel *downloadModel = notification.object;

    [self.dataArr enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 更新数据源
            self.dataArr[idx] = downloadModel;
            
            // 主线程刷新cell 这里可能存在闪退，如果发生闪退优先检查此处
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (downloadModel.state == HWDownloadStateFinish) {
                    [self getCacheData];
                }else{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            });
            *stop = YES;
        }
    }];

}



@end
