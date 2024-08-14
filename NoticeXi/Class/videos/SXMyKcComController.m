//
//  SXMyKcComController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXMyKcComController.h"
#import "CBAutoScrollLabel.h"
#import "SXKcComScoreListCell.h"
#import "SXHasBuyPayVideoController.h"
@interface SXMyKcComController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *kcView;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation SXMyKcComController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIView *headeView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 128)];
    self.tableView.tableHeaderView = headeView;
    self.headerView = headeView;
    
    [headeView addSubview:self.kcView];
    [self refreshDeleteUI];
    
    [self.tableView registerClass:[SXKcComScoreListCell class] forCellReuseIdentifier:@"cell"];
    [self.dataArr addObject:self.comModel];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.comModel.status.intValue != 1) {
        return 0;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKcComScoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.seeSelf = YES;
    cell.comModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.deleteScoreBlock = ^(SXKcComDetailModel * _Nonnull comM) {
        [weakSelf showToastWithText:@"删除成功"];
        weakSelf.comModel = comM;
        [weakSelf refreshDeleteUI];
        [weakSelf.tableView reloadData];
        if (weakSelf.deleteScoreBlock) {
            weakSelf.deleteScoreBlock(comM);
        }
    };
    return cell;
}

- (void)refreshDeleteUI{
    if (self.comModel.status.intValue != 1) {
        self.deleteView.hidden = NO;
        self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, CGRectGetMaxY(self.deleteView.frame));
    }
}

- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView  alloc] initWithFrame:CGRectMake(15, 45+84, DR_SCREEN_WIDTH-30, 54)];
        _deleteView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_deleteView setAllCorner:10];
        [self.headerView addSubview:_deleteView];
        
        //头像
        UIImageView *_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
        [_iconImageView setAllCorner:12];
        [_deleteView addSubview:_iconImageView];
        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
        
        //昵称
        UILabel *_nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(47,16, DR_SCREEN_WIDTH-56-30, 22)];
        _nickNameL.font = XGSIXBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _nickNameL.text = @"我的评价";
        [_deleteView addSubview:_nickNameL];
        
        UILabel *_deleteL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-100-15,18, 100, 17)];
        _deleteL.font = TWOTEXTFONTSIZE;
        _deleteL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _deleteL.text = @"评价已删除";
        _deleteL.textAlignment = NSTextAlignmentRight;
        [_deleteView addSubview:_deleteL];
    }
    return _deleteView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKcComDetailModel *model = self.dataArr[indexPath.row];
    if (model.label_info.count || model.content) {
        return 57+45+10+model.labelHeight+model.contentHeight+10;
    }else{
        return 57+45+10+20;
    }
}

- (UIView *)kcView{
    if (!_kcView) {
        _kcView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 84)];
        _kcView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFC"];
        [_kcView setAllCorner:10];
        
        UIImageView *coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 48, 64)];
        [coverImageView setAllCorner:2];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.clipsToBounds = YES;
        [_kcView addSubview:coverImageView];
        
        CBAutoScrollLabel *_titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(66,20,DR_SCREEN_WIDTH-30-70, 21)];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        _titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_kcView addSubview:_titleL];
        
        UILabel *_markL = [[UILabel alloc] initWithFrame:CGRectMake(66,48,DR_SCREEN_WIDTH-30-70, 16)];
        _markL.font = ELEVENTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_kcView addSubview:_markL];
        
        _markL.text = [NSString stringWithFormat:@"共%@课时",self.paySearModel.episodes];
        _titleL.text = self.paySearModel.series_name;
   
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.paySearModel.simple_cover_url]];
    }
    return _kcView;
}

- (void)backClick{
    if (self.isFromCom) {
        __block UIViewController *pushVC;
        __weak typeof(self) weakSelf = self;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SXHasBuyPayVideoController class]]) {//返回到指定界面
                pushVC = obj;
                [weakSelf.navigationController popToViewController:pushVC animated:YES];
                return ;
            }
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    if (self.isFromCom) {
        return NO;
    }
    return YES;
}
@end
