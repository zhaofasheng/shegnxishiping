//
//  NoticeEditShopInfoController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditShopInfoController.h"
#import "NoticeShopDetailSection.h"
#import "NoticeXi-Swift.h"
#import "NoticeEditCard1Cell.h"
#import "NoticeEditCard2Cell.h"
#import "NoticeEditCard3Cell.h"
#import "NoticeEditCard4Cell.h"
#import "NoticeEditCardCell.h"
#import "NoticeChangeTeamNickNameView.h"
#import "KMTagListView.h"

@interface NoticeEditShopInfoController ()<KMTagListViewDelegate>
@property (nonatomic, strong) KMTagListView *labeView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL stopPlay;
@property (nonatomic, assign) BOOL needScro;
@property (nonatomic, assign) CGFloat introHeight;
@property (nonatomic, assign) CGFloat photoHeight;
@property (nonatomic, strong) UILabel *addTagsL;
@property (nonatomic, strong) UILabel *photosNumL;
@property (nonatomic, assign) BOOL isBoy;
@property (nonatomic, strong) NSMutableAttributedString *attName;
@property (nonatomic, strong) NSMutableAttributedString *attTag;
@end

@implementation NoticeEditShopInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.introHeight = 128;
    self.photoHeight = (DR_SCREEN_WIDTH-40-12)/4*1+10+8;
    self.navBarView.titleL.text = @"编辑资料";
    
    if (!self.backView) {
        [self refreshBackView];
    }
    
    [self.tableView registerClass:[NoticeEditCardCell class] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerClass:[NoticeEditCard1Cell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeEditCard2Cell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[NoticeEditCard3Cell class] forCellReuseIdentifier:@"cell3"];
    [self.tableView registerClass:[NoticeEditCard4Cell class] forCellReuseIdentifier:@"cell4"];

    [self.tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHMYWALLECT" object:nil];

    
    if (self.section > 2) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)getShopRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            [self.tableView reloadData];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

-(UILabel *)addTagsL{
    if (!_addTagsL) {
        _addTagsL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-180, 0, 160, 37)];
        _addTagsL.font = FOURTHTEENTEXTFONTSIZE;
        _addTagsL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        _addTagsL.textAlignment = NSTextAlignmentRight;
        _addTagsL.userInteractionEnabled = YES;
        _addTagsL.text = @"添加标签";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagTap)];
        [_addTagsL addGestureRecognizer:tap];
    }
    return _addTagsL;
}

-(UILabel *)photosNumL{
    if (!_photosNumL) {
        _photosNumL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-180, 0, 160, 37)];
        _photosNumL.font = FOURTHTEENTEXTFONTSIZE;
        _photosNumL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _photosNumL.textAlignment = NSTextAlignmentRight;
    }
    return _photosNumL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    
    if (section == 0) {
        headV.mainTitleLabel.text = @"店铺名称";
    }else if (section == 1){
        [_photosNumL removeFromSuperview];
        headV.mainTitleLabel.text = @"照片墙";
        [headV addSubview:self.photosNumL];
        self.photosNumL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%ld/10",self.shopModel.myShopM.photowallArr.count] setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:[NSString stringWithFormat:@"%ld",self.shopModel.myShopM.photowallArr.count] beginSize:0];
    }else if (section == 2){
        headV.mainTitleLabel.text = @"我的声音";
    }else if (section == 3){
        headV.mainTitleLabel.text = @"我的故事";
    }else if (section == 4){
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

//添加标签
- (void)addTagTap{
    if (self.shopModel.myShopM.tagsTextArr.count == 10) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NoticeChangeTeamNickNameView * nameV = [[NoticeChangeTeamNickNameView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    __block NoticeChangeTeamNickNameView *strongBlock = nameV;
    nameV.noDissMiss = YES;
    nameV.titleL.text = @"添加标签";
    nameV.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入你的关键词" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#8A8F99"]}];
    nameV.closeBtn.hidden = NO;
    [nameV.sureBtn setTitle:@"添加" forState:UIControlStateNormal];
    nameV.sureNameBlock = ^(NSString * _Nonnull name) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:name forKey:@"label"];
        [[NoticeTools getTopViewController] showHUD];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
            [[NoticeTools getTopViewController] hideHUD];

            if (success1) {
                [strongBlock dissMissView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            }else{
                NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
                if (msgModel.chatM.keyword.count) {
                    for (NSString *str in msgModel.chatM.keyword) {
                        [weakSelf setTagRedColor:str sourceString:strongBlock.nameField.text textView:strongBlock.nameField att:weakSelf.attTag];
                    }
                }else{
                    [strongBlock dissMissView];
                }
                
            }
        } fail:^(NSError * _Nullable error) {
            [strongBlock dissMissView];
            [[NoticeTools getTopViewController] hideHUD];
        }];
    };
    [nameV showNameView];
}


- (void)changeName{
    NoticeChangeShopNameView *nameView = [[NoticeChangeShopNameView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    __block NoticeChangeShopNameView *strongBlock = nameView;
    nameView.textFild.text = self.shopModel.myShopM.shop_name;
    nameView.noDissMiss = YES;
    __weak typeof(self) weakSelf = self;
    nameView.nameBlock = ^(NSString * _Nullable name) {
        if (!name) {
            return;
        }
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:name forKey:@"shop_name"];
        [[NoticeTools getTopViewController] showHUD];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
            [[NoticeTools getTopViewController] hideHUD];

            if (success1) {
                [strongBlock closeClick];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            }else{
                NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
                if (msgModel.chatM.keyword.count) {
                    for (NSString *str in msgModel.chatM.keyword) {
                        [weakSelf setNameRedColor:str sourceString:strongBlock.textFild.text textView:strongBlock.textFild att:weakSelf.attName];
                    }
                }else{
                    [strongBlock closeClick];
                }
            }
        } fail:^(NSError * _Nullable error) {
            [strongBlock closeClick];
            [[NoticeTools getTopViewController] hideHUD];
        }];

    };
    [nameView showView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 56+12+105;
    }else if (indexPath.section == 1){

        NSInteger imgNum = self.shopModel.myShopM.photowallArr.count;
        if (imgNum < 4 || imgNum == 0) {
            self.photoHeight = (DR_SCREEN_WIDTH-40-12)/4*1+10+8;
        }else if (imgNum >=3 && imgNum < 8){
            self.photoHeight = (DR_SCREEN_WIDTH-40-12)/4*2+10+8;
        }else if (imgNum >= 8){
            self.photoHeight = (DR_SCREEN_WIDTH-40-12)/4*3+10+8;
        }
        return self.photoHeight+12;
    }else if (indexPath.section == 2){
        return 36+12;
    }else if (indexPath.section == 3){
        return ((self.shopModel.myShopM.taleHeight>88)?(self.shopModel.myShopM.taleHeight+20):108)+9;
    }else{
        return self.shopModel.myShopM.tagsTextArr.count > 0? self.backView.frame.size.height : 56;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    if (indexPath.section == 0) {
        NoticeEditCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        __weak typeof(self) weakSelf = self;
        cell.changeNameBlock = ^(BOOL change) {
            [weakSelf changeName];
        };
        cell.sexBlock = ^(BOOL boy) {
            weakSelf.isBoy = boy;
            [weakSelf setSext];
        };
        cell.shopModel = self.shopModel;
        return cell;
    }else if (indexPath.section == 1){
        NoticeEditCard1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.height = self.photoHeight;
        cell.shopModel = self.shopModel;
        return cell;
    }else if (indexPath.section == 2){
        NoticeEditCard2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.shopModel = self.shopModel;
        cell.stopPlay = self.stopPlay;
        self.stopPlay = NO;
        
        cell.refreshShopModel = ^(BOOL refresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
        };
        return cell;
    }else if (indexPath.section == 3){
        NoticeEditCard3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.shopModel = self.shopModel;
        cell.refreshShopModel = ^(BOOL refresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
        };

        return cell;
    }else{
        [_backView removeFromSuperview];
        __weak typeof(self) weakSelf = self;
        NoticeEditCard4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (self.shopModel.myShopM.tagsTextArr.count) {
            cell.addtagsButton.hidden = YES;
            [cell.contentView addSubview:self.backView];
        }else{
            cell.addtagsButton.hidden = NO;
        }
        cell.editShopModelBlock = ^(BOOL edit) {
            [weakSelf addTagTap];
        };
        return cell;
    }
}

- (void)setSext{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.isBoy?@"1":@"2" forKey:@"sex"];
    [[NoticeTools getTopViewController] showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
        [[NoticeTools getTopViewController] hideHUD];

        if (success1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    if (index < self.shopModel.myShopM.tagsArr.count) {
        NoticeShopDataIdModel *tagM = self.shopModel.myShopM.tagsArr[index];
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:tagM.dataId forKey:@"id"];
        [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/wallLabel/2" Accept:@"application/vnd.shengxi.v5.6.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
   
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
    }
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    
    if (shopModel.myShopM.tagsTextArr.count) {
        if (!self.backView) {
            [self refreshBackView];
        }
        [self.labeView removeFromSuperview];
        self.labeView = nil;
        
        KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(10,10,DR_SCREEN_WIDTH-60, 0)];
        self.labeView = tagV;
        [self.backView addSubview:self.labeView];
        self.labeView.delegate_ = self;
        
        [self.labeView setupCustomeImgSubViewsWithTitles1:shopModel.myShopM.tagsTextArr];
        CGRect rect = self.labeView.frame;
        rect.size.height = self.labeView.contentSize.height+5;
        self.labeView.frame = rect;
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40,self.labeView.frame.size.height+20);
        [self.tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.stopPlay = YES;
    [self.tableView reloadData];
}

- (void)refreshBackView{
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 128)];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.backView = backView;

}


- (void)setNameRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextField*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attName = att;
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:EIGHTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}

- (void)setTagRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextField*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attTag = att;
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:EIGHTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}


@end
