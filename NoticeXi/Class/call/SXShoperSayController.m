//
//  SXShoperSayController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShoperSayController.h"
#import "SXShopSayDetailController.h"
#import "SXShopSayHeaderSectionView.h"
#import "SXShopSayDayCell.h"
@interface SXShoperSayController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation SXShoperSayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-40);
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[SXShopSayDayCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SXShopSayHeaderSectionView class] forHeaderFooterViewReuseIdentifier:@"header"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopSayDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopSayDetailController *ctl = [[SXShopSayDetailController alloc] init];
   // ctl.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //有图片高度是92;
    //物图片高度是48;
    return 92;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SXShopSayHeaderSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    NSString *day = @"09";
    NSString *all = @"09 / 09 / 2024";
    sectionView.mainTitleLabel.attributedText = [DDHAttributedMode setJiaCuString:all setSize:18 setLengthString:day beginSize:0];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
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
