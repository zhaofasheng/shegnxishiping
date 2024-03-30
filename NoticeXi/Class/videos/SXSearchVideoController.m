//
//  SXSearchVideoController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/27.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSearchVideoController.h"
#import "KMTagListView.h"
#import "NoticeVideoCollectionViewCell.h"
#import "SXPlayFullListController.h"
#import "NoticeLoginViewController.h"
#import "SXSearchThinkCell.h"
#import "SXSearchModel.h"
#import "CYWWaterFallLayout.h"
#import "SXPlayDetailController.h"
#import "UIViewController+TTCTransitionAnimator.h"
#import "TTCTransitionDelegate.h"

@interface SXSearchVideoController ()<SmallVideoPlayControllerDelegate,UITextFieldDelegate,KMTagListViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CYWWaterFallLayout *layout;
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, strong) KMTagListView *labeView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *searchHistoryArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) BOOL hasNoCreateRefsh;
@property (nonatomic, strong) SXSearchModel *defaultSearM;
@property (nonatomic, strong) NSMutableArray *localArr;

@end

@implementation SXSearchVideoController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.topicField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    

    self.searchHistoryArr = [NoticeTools getSearchArr];
    
    [self refreshHistory];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0,DR_SCREEN_WIDTH-15-40-65, 36)];
    self.topicField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.topicField.font = FOURTHTEENTEXTFONTSIZE;
    self.topicField.textColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:1];
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入搜索内容" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1]}];
    [self.topicField setupToolbarToDismissRightButton];
    [self.topicField becomeFirstResponder];
    [self.topicField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.topicField.delegate = self;
    self.topicField.returnKeyType = UIReturnKeySearch;
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[self.topicField valueForKey:@"_clearButton"] setImage:UIImageNamed(@"clear_button.png") forState:UIControlStateNormal];

    [self requestDefatut];

    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-36)/2+STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-15-62, 36)];
    [backV setAllCorner:18];
    backV.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
    [backV addSubview:self.topicField];
    [self.view addSubview:backV];
    
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
    searImg.image = UIImageNamed(@"Image_newsearchss");
    [backV addSubview:searImg];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-62,STATUS_BAR_HEIGHT, 62, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    
    [self.tableView registerClass:[SXSearchThinkCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 40;
    
}


- (void)refreshIfShowList{
    
    if (self.localArr.count) {
        [self.tableView reloadData];
        self.tableView.tableHeaderView = nil;
    }else{
        self.tableView.tableHeaderView = self.searchHistoryArr.count? self.headerView : nil;
    }
    
}

//键盘弹起
- (void)keyboardDidShow{
    
    self.tableView.hidden = NO;
    _collectionView.hidden = YES;
    self.tableView.tableFooterView = nil;
    [self refreshIfShowList];
    
}


//刷新历史搜索记录
- (void)refreshHistory{
    
    if (self.searchHistoryArr.count) {
        if (self.labeView) {
            [self.labeView removeFromSuperview];
        }
        KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,40,DR_SCREEN_WIDTH, 0)];
        self.labeView = tagV;
        self.labeView.oneClick = YES;
        self.labeView.delegate_ = self;
        [self.headerView addSubview:tagV];
        
        [self.labeView setupSubViewsWithTitles:self.searchHistoryArr];
        CGRect rect = self.labeView.frame;
        rect.size.height = self.labeView.contentSize.height+5;
        self.labeView.frame = rect;
        
        self.headerView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, 40+rect.size.height);
        
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
    }
    
}

- (void)textFieldDidChange:(id) sender {
    
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length) {
        [self requestLoacal:_field.text];
        
    }else{
        [self.localArr removeAllObjects];
        [self.tableView reloadData];
        if (self.searchHistoryArr.count) {
            [self refreshHistory];
        }
    }
    
}


//获取联想词汇
- (void)requestLoacal:(NSString *)str{
   NSString *url = [NSString stringWithFormat:@"video/search/entry?keyword=%@",[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            SXSearchModel *model = [SXSearchModel mj_objectWithKeyValues:dict];
            if (model.data.count) {
                self.localArr = [NSMutableArray arrayWithArray:model.data];
            }
            [self refreshIfShowList];
        }
    } fail:^(NSError * _Nullable error) {

    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self isEmpty:textField.text]) {
        [self showToastWithText:@"搜索不能带有纯空格文本~"];
        return YES;
    }
    
    if (textField.text && textField.text.length) {
        [self searchWith:textField.text needSave:YES];
    }
    
    return YES;
}

//判断是否全是空格
- (BOOL)isEmpty:(NSString *) str
{
    if (!str)     {
        return true;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

//搜索开始
- (void)searchWith:(NSString *)key needSave:(BOOL)needsave{
    self.topicField.text = key;
    [self.topicField resignFirstResponder];
    if (needsave) {
        BOOL already = NO;
        if (self.searchHistoryArr.count) {
            for (int i = 0;i < self.searchHistoryArr.count;i++) {
                NSString *oldStr = self.searchHistoryArr[i];
                if ([oldStr isEqualToString:key]) {
                    already = YES;
                    [self.searchHistoryArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                    break;
                }
            }
        }
 
        if (!already) {
            if (self.searchHistoryArr.count == 10) {
                [self.searchHistoryArr removeLastObject];
            }
            [self.searchHistoryArr insertObject:key atIndex:0];
            
            [NoticeTools saveSearchArr:self.searchHistoryArr];
            
            [self.labeView setupSubViewsWithTitles:self.searchHistoryArr];
            CGRect rect = self.labeView.frame;
            rect.size.height = self.labeView.contentSize.height+5;
            self.labeView.frame = rect;
            
            self.headerView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, 40+rect.size.height);
        }

    }
    
    self.isDown = YES;
    self.pageNo = 1;
    self.keyword = key;
    [self request];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

- (void)creatchreresh{
    if (!self.hasNoCreateRefsh) {
        self.hasNoCreateRefsh = YES;
        __weak typeof(self) weakSelf = self;
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.isDown = NO;
            weakSelf.pageNo++;
            [weakSelf request];
            
        }];
    }
}


- (void)request{
    if (!self.keyword) {
        return;
    }
    [self showHUD];
    [self creatchreresh];
    NSString *url = @"";
    url = [NSString stringWithFormat:@"video/search?pageNo=%ld&keyword=%@",self.pageNo,[self.keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self hideHUD];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:videoM];
            }
            
            if (self.dataArr.count) {
                self.layout.dataList = self.dataArr;
                self.tableView.hidden = YES;
                self.collectionView.hidden = NO;
                [self.collectionView reloadData];
            }else{
                self.collectionView.hidden = YES;
                self.tableView.tableHeaderView = nil;
                self.tableView.tableFooterView = self.defaultL;
                self.tableView.hidden = NO;
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

//获取默认搜索词汇
- (void)requestDefatut{
    NSString *url = @"video/search/default";
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.defaultSearM = [SXSearchModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.defaultSearM.word) {
                self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.defaultSearM.word attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1]}];
            }
        }
    } fail:^(NSError * _Nullable error) {

    }];
}

- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 4,100, 40)];
        titL.text = @"最近搜索";
        titL.font = FIFTHTEENTEXTFONTSIZE;
        titL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [_headerView addSubview:titL];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-40, 0, 40, 40)];
        [deleteBtn addTarget:self action:@selector(deleteLocalClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:UIImageNamed( @"img_deletetopictm") forState:UIControlStateNormal];
        [_headerView addSubview:deleteBtn];
    }
    return _headerView;
}

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    if (index < self.searchHistoryArr.count) {
        [self searchWith:self.searchHistoryArr[index] needSave:NO];
    }
}

//清空搜索记录
- (void)deleteLocalClick{
    self.tableView.tableHeaderView = nil;
    [self.searchHistoryArr removeAllObjects];
    [NoticeTools saveSearchArr:self.searchHistoryArr];
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //1.初始化layout
        CYWWaterFallLayout *flowLayout = [[CYWWaterFallLayout alloc] init];

        self.layout = flowLayout;
        flowLayout.columnCount = 2;
        flowLayout.itemWidth = (DR_SCREEN_WIDTH-15)/2;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //2.初始化collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT -  NAVIGATION_BAR_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectioncell"];
        [_collectionView registerClass:[NoticeVideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
  
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }

    SXPlayDetailController *ctl = [[SXPlayDetailController alloc] init];
    ctl.currentPlayModel = self.dataArr[indexPath.row];
    
//    SXPlayFullListController *ctl = [[SXPlayFullListController alloc] init];
//    ctl.modelArray = self.dataArr;
//    ctl.currentPlayIndex = indexPath.row;
//    ctl.delegate = self;
//    ctl.ttcTransitionDelegate = [[TTCTransitionDelegate alloc] init];
//    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}


#pragma mark - SmallVideoPlayControllerDelegate
- (UIView *)smallVideoPlayIndex:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]].contentView;

}
//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeVideoCollectionViewCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    if (self.dataArr.count > indexPath.row) {
        merchentCell.videoModel = self.dataArr[indexPath.row];
    }
    
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (NSMutableArray *)localArr{
    if (!_localArr) {
        _localArr = [[NSMutableArray alloc] init];
    }
    return _localArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXSearchThinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleL.text = self.localArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.localArr.count) {
        NSString *str = self.localArr[indexPath.row];
        [self searchWith:str needSave:YES];
    }
}
@end
