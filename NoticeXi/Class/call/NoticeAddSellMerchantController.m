//
//  NoticeAddSellMerchantController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddSellMerchantController.h"
#import "NoticeChatVoiceShopCell.h"
#import "NoticeShopDetailSection.h"
#import "SXAddNewGoodsController.h"
@interface NoticeAddSellMerchantController ()
@property (nonatomic, strong) NSMutableArray *voiceArr;
@property (nonatomic, strong) NSMutableArray *freeArr;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) NoticeGoodsModel *oldGoodsModel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *redL;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *addNewGoodsView;
@end

@implementation NoticeAddSellMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.text = @"服务";
    [self.tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    [self.tableView registerClass:[NoticeChatVoiceShopCell class] forCellReuseIdentifier:@"cell1"];
    
    for (NoticeGoodsModel *goods in self.goodsModel.goods_listArr) {
        goods.choice = @"0";
        for (NoticeGoodsModel *choiceM in self.sellGoodsArr) {
            if([goods.goodId isEqualToString:choiceM.goodId]){
                goods.choice = @"1";
                [self.choiceArr addObject:goods];
            }
        }
        if (goods.is_experience.boolValue) {
            [self.freeArr addObject:goods];
        }else{
            [self.voiceArr addObject:goods];
        }
        
    }
    
    [self.tableView reloadData];
    
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-40, DR_SCREEN_WIDTH-40, 40)];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];

    [self.addButton setTitle:@"确认" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-NAVIGATION_BAR_HEIGHT);
    
    [self requestGoods];
}

- (void)requestGoods{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/goodsList" Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.freeArr removeAllObjects];
            [self.voiceArr removeAllObjects];
            [self.choiceArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
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
   
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)addClick{
    if(!self.choiceArr.count){
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
        [self showToastWithText:@"请至少选中一项收费服务"];
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
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/setShopProduct" Accept:@"application/vnd.shengxi.v5.8.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [weakSelf hideHUD];
        if(success){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHGOODS" object:nil];
            if(weakSelf.refreshGoodsBlock){
                weakSelf.refreshGoodsBlock(weakSelf.choiceArr);
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChatVoiceShopCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell1.shopId = self.goodsModel.myShopM.shopId;
    cell1.goodModel = indexPath.section == 0?self.freeArr[indexPath.row] : self.voiceArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell1.changePriceBlock = ^(NoticeGoodsModel * _Nonnull goodModel) {
        [weakSelf changeGoods:goodModel];
    };
    cell1.deleteBlock = ^(NoticeGoodsModel * _Nonnull goodModel) {
        [weakSelf deleteGood:goodModel];
    };
    return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 101;
    }
    NoticeGoodsModel *goods = self.voiceArr[indexPath.row];
    return goods.nameHeight+92+15+8;
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



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.mainTitleLabel.hidden = section==0?YES:NO;
    headV.mainTitleLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    headV.mainTitleLabel.font = TWOTEXTFONTSIZE;
    headV.mainTitleLabel.attributedText = [DDHAttributedMode setJiaCuString:@"收费服务 必选" setSize:14 setColor:[UIColor colorWithHexString:@"#14151A"] setLengthString:@"收费服务" beginSize:0];
    [self.redL removeFromSuperview];
    [_addNewGoodsView removeFromSuperview];
    if (section == 1) {
        if (self.voiceArr.count) {
            [headV addSubview:self.addNewGoodsView];
        }
        [headV addSubview:self.redL];
        headV.mainTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.redL.frame), 28, 200, 37);
    }
  
    if (self.voiceArr.count) {
        self.tableView.tableFooterView = nil;
    }else{
        self.tableView.tableFooterView = self.footView;
    }
    return headV;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 65;
}

- (UILabel *)redL{
    if (!_redL) {
        _redL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 28, GET_STRWIDTH(@"*", 14, 37), 37)];
        _redL.text = @"*";
        _redL.font = XGFourthBoldFontSize;
        _redL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        
    }
    return _redL;
}


- (UIView *)addNewGoodsView{
    if (!_addNewGoodsView) {
        _addNewGoodsView = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-78-15, 28, 78, 37)];
        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 17/2, 20, 20)];
        imageV.userInteractionEnabled = YES;
        imageV.image = UIImageNamed(@"sx_addnewsgood_img");
        [_addNewGoodsView addSubview:imageV];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(23, 0, 56, 37)];
        label.font = XGFourthBoldFontSize;
        label.text = @"新增服务";
        label.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [_addNewGoodsView addSubview:label];
        
        _addNewGoodsView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewsGoods)];
        [_addNewGoodsView addGestureRecognizer:tap];
    }
    return _addNewGoodsView;
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-30)*116/345+20)];
        _footView.backgroundColor = [UIColor whiteColor];


        UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30)*116/345)];
        [button setBackgroundImage:UIImageNamed(@"sx_footaddnewsgood") forState:UIControlStateNormal];
        [_footView addSubview:button];
        [button addTarget:self action:@selector(addNewsGoods) forControlEvents:UIControlEventTouchUpInside];

    }
    return _footView;
}

- (void)addNewsGoods{
    SXAddNewGoodsController *ctl = [[SXAddNewGoodsController alloc] init];
    ctl.goodsModel = self.goodsModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshBlock = ^(BOOL refresh) {
        [weakSelf requestGoods];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)changeGoods:(NoticeGoodsModel *)goodM{
    SXAddNewGoodsController *ctl = [[SXAddNewGoodsController alloc] init];
    ctl.goodsModel = self.goodsModel;
    ctl.changeGoodModel = goodM;
    __weak typeof(self) weakSelf = self;
    ctl.refreshBlock = ^(BOOL refresh) {
        [weakSelf requestGoods];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)deleteGood:(NoticeGoodsModel *)goodM{

    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"shop/goods/%@",goodM.goodId] Accept:@"application/vnd.shengxi.v5.8.2+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    for (NoticeGoodsModel *oldM in self.voiceArr) {
        if ([oldM.goodId isEqualToString:goodM.goodId]) {
            [self.voiceArr removeObject:oldM];
            [self.tableView reloadData];
            break;
        }
    }
}
@end
