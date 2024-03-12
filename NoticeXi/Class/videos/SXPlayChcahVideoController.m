//
//  SXPlayChcahVideoController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayChcahVideoController.h"

#import "SXDownVideoheaderView.h"
#import "NoticeDownloadVoiceCell.h"
@interface SXPlayChcahVideoController ()
@property (nonatomic, strong) NSMutableArray <HWDownloadModel *> *hasfinishArr;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation SXPlayChcahVideoController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.navBarView.hidden = YES;
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9));
    [self.tableView registerClass:[NoticeDownloadVoiceCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SXDownVideoheaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    self.tableView.rowHeight = 74;
    
    self.hasfinishArr = [[NSMutableArray alloc] init];
    //获取所有下载完成的数据
    [self.hasfinishArr removeAllObjects];
    for (HWDownloadModel *finishedmodel in [[HWDataBaseManager shareManager] getAllDownloadedData]) {
        [self.hasfinishArr addObject:finishedmodel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HWDownloadModel *model = self.hasfinishArr[indexPath.row];
    if ([model.vid isEqualToString:self.currentPlayModel.vid]) {
        return;
    }
    self.currentPlayModel = model;
    if (self.choiceVideoBlock) {
        self.choiceVideoBlock(model);
    }
    [self.tableView reloadData];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        HWDownloadModel *model = weakSelf.hasfinishArr[indexPath.row];
        if ([model.vid isEqualToString:weakSelf.currentPlayModel.vid]) {
            [weakSelf showToastWithText:@"当前播放的视频不允许删除哦~"];
            return;
        }
   
      //删除数据源
        [[HWDownloadManager shareManager] deleteTaskAndCache:model];
        [weakSelf.hasfinishArr removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
   
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    Configuration.performsFirstActionWithFullSwipe = NO;
    return Configuration;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SXDownVideoheaderView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.mainTitleLabel.text = [NSString stringWithFormat:@"已缓存(%ld)",self.hasfinishArr.count];
    headV.mainTitleLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
    headV.mainTitleLabel.font = XGFourthBoldFontSize;
    return headV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hasfinishArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDownloadVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentPlayId = self.currentPlayModel.vid;
    cell.model = self.hasfinishArr[indexPath.row];
    return cell;
}

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
}

@end
