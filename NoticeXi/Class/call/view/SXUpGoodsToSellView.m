//
//  SXUpGoodsToSellView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUpGoodsToSellView.h"
#import "NoticeChatVoiceShopCell.h"
#import "NoticeShopDetailSection.h"
@implementation SXUpGoodsToSellView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-150)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-50, 0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"sx_blackclose_img") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100,50)];
        contentL.font = XGEightBoldFontSize;
        contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        contentL.text = @"上架服务";
        [self.contentView addSubview:contentL];

        self.isDown = YES;
        self.pageNo = 1;
        self.voiceArr = [[NSMutableArray alloc] init];
        
        self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+5, DR_SCREEN_WIDTH-40, 40)];
        [self.addButton setAllCorner:20];
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addButton setTitle:@"确认" forState:UIControlStateNormal];
        self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.addButton];
        [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self request];
    }
    return self;
}


- (void)addClick{
    if(!self.choiceArr.count){
        [[NoticeTools getTopViewController] showToastWithText:@"请选择要上架的商品"];
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    BOOL hasNoFree = NO;
    for (NoticeGoodsModel *choiceM in self.choiceArr) {
        if (!choiceM.is_experience.boolValue) {
            hasNoFree = YES;
            break;
        }
    }
    if (!hasNoFree) {
        [[NoticeTools getTopViewController] showToastWithText:@"必须添加一个付费商品才能营业哦~"];
        return;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NoticeGoodsModel *goods in self.choiceArr) {
        [arr addObject:goods.goodId];
    }
    if (arr.count) {
        [parm setObject:[arr componentsJoinedByString:@","] forKey:@"goodsId"];
    }


    __weak typeof(self) weakSelf = self;
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/setShopProduct" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if(success){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHGOODS" object:nil];
            if(weakSelf.refreshGoodsBlock){
                weakSelf.refreshGoodsBlock(weakSelf.choiceArr);
            }
            
            [weakSelf cancelClick];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
    
}




- (void)createRefesh{
    
//    __weak SXUpGoodsToSellView *ctl = self;
//
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        ctl.isDown = YES;
//        ctl.pageNo = 1;
//        [ctl request];
//    }];
//    // 设置颜色
//    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
//    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
//    self.tableView.mj_header = header;
//    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        //上拉
//        ctl.isDown = NO;
//        ctl.pageNo++;
//        [ctl request];
//    }];
}

- (void)request{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/goodsList" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            [self.choiceArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"][@"goods_list"]) {
                NoticeGoodsModel *goods = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                goods.choice = goods.is_selling.boolValue? @"1" : @"0";
    
                if (goods.tagString) {
                    goods.nameHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-96-60 string:goods.goods_name andFirstWidth:GET_STRWIDTH(goods.tagString, 11, 20)+10+5];
                    if (goods.nameHeight < 20) {
                        goods.nameHeight = 20;
                    }
                }else{
                    goods.nameHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-96-60 string:goods.goods_name isJiacu:YES];
                    if (goods.nameHeight < 20) {
                        goods.nameHeight = 20;
                    }
                }
                
                if(goods.choice.boolValue){
                    [self.choiceArr addObject:goods];
                }
                if (goods.is_experience.boolValue) {
                    [self.freeArr addObject:goods];
                }else{
                    [self.voiceArr addObject:goods];
                }
                
            }
//            if(self.choiceArr.count){
//                self.addButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
//                [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
//            }else{
//                self.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
//                [self.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
//            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChatVoiceShopCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell1.noneedEdit = YES;
    cell1.shopId = self.goodsModel.myShopM.shopId;
    cell1.goodModel = indexPath.section == 0?self.freeArr[indexPath.row] : self.voiceArr[indexPath.row];

    return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 101;
    }
    NoticeGoodsModel *goods = self.voiceArr[indexPath.row];
    return goods.nameHeight+92+15+8-45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.freeArr.count;
    }
    return self.voiceArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];

    return headV;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 10;
}
- (void)showATView{

    self.isDown = YES;
    self.pageNo = 1;
    [self request];
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                NoticeGoodsModel *voiceChatM = indexPath.section==0?weakSelf.freeArr[indexPath.row] : weakSelf.voiceArr[indexPath.row];
                voiceChatM.choice = voiceChatM.choice.boolValue?@"0":@"1";
                [weakSelf.tableView reloadData];
                
                [self.choiceArr removeAllObjects];
                
                for (NoticeGoodsModel *voiceM in weakSelf.voiceArr) {
                    if(voiceM.choice.boolValue){
                        [weakSelf.choiceArr addObject:voiceM];
                    }
                }
                
                for (NoticeGoodsModel *voiceM in weakSelf.freeArr) {
                    if(voiceM.choice.boolValue){
                        [weakSelf.choiceArr addObject:voiceM];
                    }
                }
        
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:@"有麦克风权限才可以开通语音通话功能哦~" sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
}



#pragma mark - Getter and Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, self.contentView.frame.size.height-50-TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 94;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
        [_tableView registerClass:NoticeChatVoiceShopCell.class forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tableView];
    }
    return _tableView;
}


- (NSMutableArray *)voiceArr{
    if(!_voiceArr){
        _voiceArr = [[NSMutableArray alloc] init];
    }
    return _voiceArr;
}


- (NSMutableArray *)freeArr{
    if(!_freeArr){
        _freeArr = [[NSMutableArray alloc] init];
    }
    return _freeArr;
}

- (NSMutableArray *)choiceArr{
    if(!_choiceArr){
        _choiceArr = [[NSMutableArray alloc] init];
    }
    return _choiceArr;
}


@end
