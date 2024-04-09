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

@property (nonatomic, assign) CGFloat introHeight;
@property (nonatomic, assign) CGFloat photoHeight;

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

    [self.tableView reloadData];
}


-(UILabel *)addTagsL{
    if (!_addTagsL) {
        _addTagsL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-180, 0, 160, 37)];
        _addTagsL.font = FOURTHTEENTEXTFONTSIZE;
        _addTagsL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        _addTagsL.textAlignment = NSTextAlignmentRight;
        _addTagsL.userInteractionEnabled = YES;
        _addTagsL.text = @"添加标签";
    }
    return _addTagsL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (section == 0){
        headV.mainTitleLabel.text = @"照片墙";
    }else if (section == 1){
        headV.mainTitleLabel.text = @"我的声音";
    }else if (section == 2){
        headV.mainTitleLabel.text = @"我的故事";
    }else if (section == 3){
        [_addTagsL removeFromSuperview];
        if (self.shopModel.myShopM.tagsTextArr.count) {
            [headV addSubview:self.addTagsL];
            if (self.shopModel.myShopM.tagsTextArr.count == 10) {
                self.addTagsL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            }else{
                self.addTagsL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
            }
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
       self.photoHeight = (DR_SCREEN_WIDTH-40-12)/4*1+10+8;
        return self.photoHeight+12;
    }else if (indexPath.section == 1){
        return 36+12;
    }else if (indexPath.section == 2){
        return ((self.shopModel.myShopM.taleHeight>88)?(self.shopModel.myShopM.taleHeight+20):108)+9;
    }else{
        return 56;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0){
        NoticeEditCard1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.height = self.photoHeight;
        cell.shopModel = self.shopModel;
        return cell;
    }else if (indexPath.section == 1){
        NoticeEditCard2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.shopModel = self.shopModel;
    
        return cell;
    }else if (indexPath.section == 2){
        NoticeEditCard3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.shopModel = self.shopModel;
        return cell;
    }else{
        NoticeEditCard4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        return cell;
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
