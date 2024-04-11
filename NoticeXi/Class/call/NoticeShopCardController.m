//
//  NoticeShopCardController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopCardController.h"
#import "NoticeShopDetailSection.h"
#import "NoticeXi-Swift.h"
#import "NoticeEditCard1Cell.h"
#import "NoticeEditCard2Cell.h"
#import "NoticeEditCard3Cell.h"
#import "NoticeEditCard4Cell.h"
#import "NoticeEditCardCell.h"

@interface NoticeShopCardController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL stopPlay;
@property (nonatomic, assign) CGFloat introHeight;
@property (nonatomic, assign) CGFloat photoHeight;
@property (nonatomic, strong) UIView *tagsView;
@property (nonatomic, strong) UILabel *addTagsL;

@end

@implementation NoticeShopCardController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-50-40);
  
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.introHeight = 128;
    self.photoHeight = (DR_SCREEN_WIDTH-40-12)/4*1+10+8;
  
    [self.tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [self.tableView registerClass:[NoticeEditCardCell class] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerClass:[NoticeEditCard1Cell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeEditCard2Cell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[NoticeEditCard3Cell class] forCellReuseIdentifier:@"cell3"];
    [self.tableView registerClass:[NoticeEditCard4Cell class] forCellReuseIdentifier:@"cell4"];
    
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;

    if (shopModel.myShopM.tagsTextArr.count) {
        CGFloat tagsHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-60 string:shopModel.myShopM.tagString isJiacu:NO];
        self.tagsView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, (tagsHeight < 36 ? 56 : (tagsHeight + 20)));
        self.addTagsL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.myShopM.tagString];
        self.addTagsL.frame = CGRectMake(10, 10, DR_SCREEN_WIDTH-60, tagsHeight);
    }
    
    [self.tableView reloadData];
}


-(UILabel *)addTagsL{
    if (!_addTagsL) {
        _addTagsL = [[UILabel  alloc] initWithFrame:CGRectZero];
        _addTagsL.font = FOURTHTEENTEXTFONTSIZE;
        _addTagsL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _addTagsL.numberOfLines = 0;
        _addTagsL.userInteractionEnabled = YES;
    }
    return _addTagsL;
}

- (UIView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 56)];
        _tagsView.layer.cornerRadius = 10;
        _tagsView.layer.masksToBounds = YES;
        _tagsView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_tagsView addSubview:self.addTagsL];
    }
    return _tagsView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    __weak typeof(self) weakSelf = self;
    headV.editShopBlock = ^(BOOL edit) {
        [weakSelf editShopInfo];
    };
    headV.subEditView.hidden = YES;
    if (section == 0){
        headV.mainTitleLabel.text = @"照片墙";
        if (self.shopModel.myShopM.photowallArr.count) {
            headV.subEditView.hidden = NO;
        }
    }else if (section == 1){
        headV.mainTitleLabel.text = @"我的声音";
        if (self.shopModel.myShopM.introduce_len.intValue) {
            headV.subEditView.hidden = NO;
        }
    }else if (section == 2){
        headV.mainTitleLabel.text = @"我的故事";
        if (self.shopModel.myShopM.tale) {
            headV.subEditView.hidden = NO;
        }
    }else if (section == 3){
        if (self.shopModel.myShopM.tagsTextArr.count) {
            headV.subEditView.hidden = NO;
        }
        headV.mainTitleLabel.text = @"个性标签";
    }
    return headV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section == 0){
        return self.photoHeight+12;
    }else if (indexPath.section == 1){
        return 36+12;
    }else if (indexPath.section == 2){
        return ((self.shopModel.myShopM.taleHeight>88)?(self.shopModel.myShopM.taleHeight+20):108)+9;
    }else{
        if (self.shopModel.myShopM.tagsTextArr.count) {
            CGFloat tagsHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-60 string:self.shopModel.myShopM.tagString isJiacu:NO];
            return (tagsHeight < 36 ? 56 : (tagsHeight + 20))+20;
        }
        return 56;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0){
        NoticeEditCard1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.justShow = YES;
        cell.editShopBlock = ^(BOOL edit) {
            [weakSelf editShopInfo];
        };
        cell.height = self.photoHeight;
        cell.shopModel = self.shopModel;
        return cell;
    }else if (indexPath.section == 1){
        NoticeEditCard2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.justShow = YES;
        cell.shopModel = self.shopModel;
        cell.editShopBlock = ^(BOOL edit) {
            [weakSelf editShopInfo];
        };
        return cell;
    }else if (indexPath.section == 2){
        NoticeEditCard3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.justShow = YES;
        cell.shopModel = self.shopModel;
        return cell;
    }else{
        
        NoticeEditCard4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        
        cell.editShopModelBlock = ^(BOOL edit) {
            [weakSelf editShopInfo];
        };
        
        [_tagsView removeFromSuperview];
        cell.addtagsButton.hidden = NO;
        if (self.shopModel.myShopM.tagsTextArr.count) {
            cell.addtagsButton.hidden = YES;
            [cell addSubview:self.tagsView];
        }
        
        return cell;
    }
}

- (void)editShopInfo{
    if (self.editShopModelBlock) {
        self.editShopModelBlock(YES);
    }
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
