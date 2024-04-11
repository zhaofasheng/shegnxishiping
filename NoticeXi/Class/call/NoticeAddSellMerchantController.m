//
//  NoticeAddSellMerchantController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddSellMerchantController.h"
#import "NoticeChatVoiceShopCell.h"
#import "NoticeChatTextCell.h"

@interface NoticeAddSellMerchantController ()
@property (nonatomic, strong) NSMutableArray *voiceArr;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) NoticeGoodsModel *oldGoodsModel;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation NoticeAddSellMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.text = @"服务";
    self.tableView.rowHeight = 160;
    
    [self.tableView registerClass:[NoticeChatVoiceShopCell class] forCellReuseIdentifier:@"cell1"];
    
    for (NoticeGoodsModel *goods in self.goodsModel.goods_listArr) {
        goods.choice = @"0";
        for (NoticeGoodsModel *choiceM in self.sellGoodsArr) {
            if([goods.goodId isEqualToString:choiceM.goodId]){
                goods.choice = @"1";
                [self.choiceArr addObject:goods];
            }
        }
        [self.voiceArr addObject:goods];
    }
    
    [self.tableView reloadData];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-40, DR_SCREEN_WIDTH-40, 40)];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.layer.masksToBounds = YES;
    if(self.choiceArr.count){
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }

    [self.addButton setTitle:@"添加服务" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-NAVIGATION_BAR_HEIGHT);
    
    [self requestGoods];
}

- (void)requestGoods{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/goodsList" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            [self.choiceArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"][@"goods_list"]) {
                NoticeGoodsModel *goods = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                goods.choice = goods.is_selling.boolValue? @"1" : @"0";
                
                if(goods.choice.boolValue){
                    [self.choiceArr addObject:goods];
                }
                
                [self.voiceArr addObject:goods];
            }
            if(self.choiceArr.count){
                self.addButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
                [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            }else{
                self.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
                [self.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (NSMutableArray *)choiceArr{
    if(!_choiceArr){
        _choiceArr = [[NSMutableArray alloc] init];
    }
    return _choiceArr;
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
        [self showToastWithText:@"必须添加一个付费商品才能营业哦~"];
        return;
    }
    if(self.choiceArr.count==1){
        NoticeGoodsModel *good1 = self.choiceArr[0];
        [parm setObject:good1.goodId forKey:@"goodsId"];
    }else if (self.choiceArr.count == 2){
        NoticeGoodsModel *good1 = self.choiceArr[0];
        NoticeGoodsModel *good2 = self.choiceArr[1];
        [parm setObject:[NSString stringWithFormat:@"%@,%@",good1.goodId,good2.goodId] forKey:@"goodsId"];
    }
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/setShopProduct" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                NoticeGoodsModel *voiceChatM = weakSelf.voiceArr[indexPath.row];
                voiceChatM.choice = voiceChatM.choice.boolValue?@"0":@"1";
                [weakSelf.tableView reloadData];
                
                [self.choiceArr removeAllObjects];
                for (NoticeGoodsModel *voiceM in weakSelf.voiceArr) {
                    if(voiceM.choice.boolValue){
                        [weakSelf.choiceArr addObject:voiceM];
                    }
                }
        
                if(weakSelf.choiceArr.count){
                    weakSelf.addButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
                    [weakSelf.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                }else{
                    weakSelf.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
                    [weakSelf.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
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
    cell1.goodModel = self.voiceArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell1.changePriceBlock = ^(NSString * _Nonnull price) {
        if(weakSelf.changePriceBlock){
            weakSelf.changePriceBlock(price);
        }
    };
    return cell1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voiceArr.count;
}

- (NSMutableArray *)voiceArr{
    if(!_voiceArr){
        _voiceArr = [[NSMutableArray alloc] init];
    }
    return _voiceArr;
}



@end
