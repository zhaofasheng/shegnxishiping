//
//  SXPayVideoPlayDetailListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayVideoPlayDetailListController.h"
#import "SXPlayPayVideoDetailListCell.h"
#import "NoticeLoginViewController.h"
@interface SXPayVideoPlayDetailListController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign) NSInteger isfirstin;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation SXPayVideoPlayDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.navBarView.hidden = YES;
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-50);
    
    [self.tableView registerClass:[SXPlayPayVideoDetailListCell class] forCellReuseIdentifier:@"cell"];
    self.isfirstin = YES;
    self.tableView.rowHeight = 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    SXSearisVideoListModel *model = self.searisArr[indexPath.row];
 
    if ([model.videoId isEqualToString:self.currentPlayModel.videoId]){
        return;
    }
    [self refreshCurrentModel:model needScro:NO];
   
}

- (void)refreshCurrentModel:(SXSearisVideoListModel *)currentM needScro:(BOOL)needScrolle{
    self.currentPlayModel = currentM;
    [self.tableView reloadData];
    if (needScrolle) {
        for (int i = 0; i < self.searisArr.count; i++) {
            SXSearisVideoListModel *model = self.searisArr[i];
            if ([model.videoId isEqualToString:self.currentPlayModel.videoId]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                break;
            }
        }
    }

    if (self.choiceVideoBlock) {
        self.choiceVideoBlock(currentM);
    }
}

- (void)playNext{
    if (self.currentPlayModel) {
        for (int i = 0; i < self.searisArr.count; i++) {
            SXSearisVideoListModel *model = self.searisArr[i];
            if ([model.videoId isEqualToString:self.currentPlayModel.videoId]) {
                if (self.searisArr.count > (i+1)) {
                    SXSearisVideoListModel *nextModel = self.searisArr[i+1];
                    self.currentPlayModel = nextModel;
                    [self.tableView reloadData];
                    if (self.choiceVideoBlock) {
                        self.choiceVideoBlock(nextModel);
                    }
                }
                break;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXPlayPayVideoDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.paySearModel = self.paySearModel;
    cell.currentVideo = self.currentPlayModel;
    cell.videoModel = self.searisArr[indexPath.row];
    cell.fgView.hidden = NO;
    cell.fgView1.hidden = NO;
    if (indexPath.row == 0) {
        cell.fgView1.hidden = YES;
        [cell.backView setCornerOnTop:10];
    }else if(indexPath.row == 30-1){
        cell.fgView.hidden = YES;
        [cell.backView setCornerOnBottom:10];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searisArr.count;
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
@end
