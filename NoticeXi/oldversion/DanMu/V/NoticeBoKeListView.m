//
//  NoticeBoKeListView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeListView.h"

@implementation NoticeBoKeListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
   
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-134+20)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_contentView setCornerOnTop:20];
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools getLocalType]==1?@"Playlist": ([NoticeTools getLocalType]==2?@"リスト": @"播放列表");
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_contentView addSubview:label];
        self.titleL = label;
        
        self.isNew = NO;
        self.pageNo = 1;
        
        NSString *str = [NoticeTools chinese:@"新-旧" english:@"New" japan:@"新-旧"];
        self.sortButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-24-GET_STRWIDTH(str, 14, 20)-22, 50, 26+GET_STRWIDTH(str, 14, 20), 44)];
        [self.sortButton setImage:UIImageNamed(@"Image_isnew") forState:UIControlStateNormal];
        [self.sortButton setTitle:str forState:UIControlStateNormal];
        self.sortButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.sortButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [_contentView addSubview:self.sortButton];
        [self.sortButton addTarget:self action:@selector(sortClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.choiceButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(20, 50, 16+GET_STRWIDTH(@"选集(1-30)", 14, 20),44)];
        [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(1-30)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"]] forState:UIControlStateNormal];
        [self.choiceButton setImage:UIImageNamed(@"Image_choice30") forState:UIControlStateNormal];
        self.choiceButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        self.choiceButton.buttonImagePosition = FSCustomButtonImagePositionRight;
        [self.choiceButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [_contentView addSubview:self.choiceButton];
        [self.choiceButton addTarget:self action:@selector(choiceClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-50-BOTTOM_HEIGHT-20,DR_SCREEN_WIDTH, 50)];
        [button setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50+44, DR_SCREEN_WIDTH, _contentView.frame.size.height-20-50-50-BOTTOM_HEIGHT-10-44)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 72;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[NoticeBoKeListCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        
        UILabel *marklabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        marklabel.text = [NoticeTools chinese:@"列表一页仅展示30条内容哦~" english:@"30 per page" japan:@"ページあたり30記事"];
        marklabel.font = TWOTEXTFONTSIZE;
        marklabel.textAlignment = NSTextAlignmentCenter;
        marklabel.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.tableView.tableFooterView = marklabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), DR_SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,49, DR_SCREEN_WIDTH, 1)];
        line1.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line1];
        
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBoKeBeDelete:) name:@"DeleteBoKeNotification" object:nil];
    }
    return self;
}

- (NotiePageNoView *)pageView{
    if(!_pageView){
        _pageView = [[NotiePageNoView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _pageView.choicePageNoBlock = ^(NSInteger pageNo) {
            if(pageNo == weakSelf.pageNo){
                return;
            }
            weakSelf.pageNo = pageNo;
            [weakSelf requestList];
        };
    }
    return _pageView;
}

- (void)choiceClick{
    [self.pageView show];
    self.pageView.currentPage = self.pageNo;
    self.pageView.allCount = self.allModel.allNum.integerValue;
}

- (void)sortClick{
    if(!self.choiceModel || !self.dataArr.count){
        return;
    }
    self.isNew = !self.isNew;
    if(self.isNew){
        [self.sortButton setImage:UIImageNamed(@"Image_isnew") forState:UIControlStateNormal];
        [self.sortButton setTitle:[NoticeTools chinese:@"新-旧" english:@"New" japan:@"新-旧"] forState:UIControlStateNormal];
    }else{
        [self.sortButton setImage:UIImageNamed(@"Image_isold") forState:UIControlStateNormal];
        [self.sortButton setTitle:[NoticeTools chinese:@"旧-新" english:@"Old" japan:@"旧-新"] forState:UIControlStateNormal];
    }
    
    NSArray *arr = [[self.dataArr reverseObjectEnumerator] allObjects];
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    [self.tableView reloadData];
    
    if(self.isNew){
        [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(%ld-%ld)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"],30*(self.pageNo-1)+1,30*(self.pageNo-1)+self.dataArr.count] forState:UIControlStateNormal];
    }else{
        [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(%ld-%ld)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"],30*(self.pageNo-1)+self.dataArr.count,30*(self.pageNo-1)+1] forState:UIControlStateNormal];
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(self.dataArr.count && appdel.floatView.currentbokeModel){
        
        appdel.floatView.bokeArr = self.dataArr;
        for (int i = 0; i < self.dataArr.count; i++) {
            NoticeDanMuModel *arrM = self.dataArr[i];
            if([arrM.podcast_no isEqualToString:appdel.floatView.currentbokeModel.podcast_no]){
                appdel.floatView.currentTag = i;
                break;
            }
        }
    }

}

- (void)getBoKeBeDelete:(NSNotification*)notification{
    if (self.dataArr.count) {
        for (NoticeDanMuModel *bokeM in self.dataArr) {
            NSDictionary *nameDictionary = [notification userInfo];
            NSString *num = nameDictionary[@"danmuNumber"];
            if ([bokeM.podcast_no isEqualToString:num]) {
                [self.dataArr removeObject:bokeM];
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.choiceBoKeBlock) {
        self.choiceBoKeBlock(self.dataArr[indexPath.row]);
    }
    [self dissMissTap];
}

- (void)setChoiceModel:(NoticeDanMuModel *)choiceModel{
    _choiceModel = choiceModel;
    if (!self.dataArr.count) {
        [self requestCurrent];
    }else{
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBoKeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentPageNo = self.pageNo;
    cell.allBokeNumber = self.allModel.allNum.integerValue;
    cell.isNew = self.isNew;
    cell.allCount = self.dataArr.count;
    cell.currentIndex = indexPath.row;
    if(self.dataArr.count && (indexPath.row <= self.dataArr.count-1)){
        cell.model = self.dataArr[indexPath.row];
        if ([cell.model.podcast_no isEqualToString:self.choiceModel.podcast_no]) {
            cell.isChoice = YES;
        }else{
            cell.isChoice = NO;
        }
    }

    return cell;
}

- (void)requestCurrent{
    NSString *url = self.isSClist ? [NSString stringWithFormat:@"podcastCollect/%@?sort=2",self.choiceModel.podcast_no] : [NSString stringWithFormat:@"podcast/%@/%@?sort=2",self.choiceModel.podcast_no,self.choiceModel.user_id];
    NSString *accept = self.isSClist ? @"application/vnd.shengxi.v5.5.8+json" : @"application/vnd.shengxi.v5.4.3+json";
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.allModel = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            self.pageNo = self.allModel.pageNo.integerValue;
            self.upPageNo = self.allModel.pageNo.integerValue;
            if (self.pageNo == 1) {
                self.hasLoadFirstNum = YES;
            }
            NSString *begStr = self.isSClist? @"已收藏" : ([NoticeTools getLocalType]==1?@"Playlist": ([NoticeTools getLocalType]==2?@"リスト": @"播放列表"));
            self.titleL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@(%@)",begStr,self.allModel.allNum] setSize:14 setLengthString:[NSString stringWithFormat:@"(%@)",self.allModel.allNum] beginSize:begStr.length];
            for (NSDictionary *dic in self.allModel.list) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                if ([model.podcast_no isEqualToString:self.choiceModel.podcast_no]) {
                    model.isChoice = YES;
                }
                [self.dataArr addObject:model];
            }
            if(self.isNew){
                [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(%ld-%ld)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"],30*(self.pageNo-1)+1,30*(self.pageNo-1)+self.dataArr.count] forState:UIControlStateNormal];
            }else{
                [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(%ld-%ld)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"],30*(self.pageNo-1)+self.dataArr.count,30*(self.pageNo-1)+1] forState:UIControlStateNormal];
                NSArray *arr = [[self.dataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:arr];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)requestList{
    NSString *url = self.isSClist ? [NSString stringWithFormat:@"podcastCollect?sort=2&pageNo=%ld",self.pageNo] : [NSString stringWithFormat:@"podcast/%@?pageNo=%ld&sort=2",self.choiceModel.user_id,self.pageNo];
    NSString *accept = self.isSClist ? @"application/vnd.shengxi.v5.5.8+json" : @"application/vnd.shengxi.v5.4.3+json";
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
  
        if (success) {
            if (self.pageNo == 1) {
                self.hasLoadFirstNum = YES;
            }
            [self.dataArr removeAllObjects];
            
            NoticeDanMuModel *dataModel = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            
            for (NSDictionary *dic in (self.isSClist? dataModel.list : dict[@"data"])) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                if ([model.podcast_no isEqualToString:self.choiceModel.podcast_no]) {
                    model.isChoice = YES;
                }
                [self.dataArr addObject:model];
            }
            if(self.isNew){
                [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(%ld-%ld)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"],30*(self.pageNo-1)+1,30*(self.pageNo-1)+self.dataArr.count] forState:UIControlStateNormal];
            }else{
                [self.choiceButton setTitle:[NSString stringWithFormat:@"%@(%ld-%ld)",[NoticeTools chinese:@"选集" english:@"ID" japan:@"選ぶ"],30*(self.pageNo-1)+self.dataArr.count,30*(self.pageNo-1)+1] forState:UIControlStateNormal];
                NSArray *arr = [[self.dataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:arr];
            }
        
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {

    }];
}


- (void)show{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height+20, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{

    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGesture) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if ([touchView isKindOfClass:[UIScrollView class]]) {
                self.scrollView = (UIScrollView *)touchView;
                self.isDragScrollView = YES;
                break;
            }else if (touchView == self.contentView) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = (UIView *)[touchView nextResponder];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
     if (gestureRecognizer == self.panGesture) {
        return YES;
    }
    return YES;
}

// 是否与其他手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.contentView];
    if (self.isDragScrollView) {
        // 当UIScrollView在最顶部时，处理视图的滑动
        if (self.scrollView.contentOffset.y <= 0) {
            if (translation.y > 0) { // 向下拖拽
                self.scrollView.contentOffset = CGPointZero;
                self.scrollView.panGestureRecognizer.enabled = NO;
                self.isDragScrollView = NO;
                
                CGRect contentFrame = self.contentView.frame;
                contentFrame.origin.y += translation.y;
                self.contentView.frame = contentFrame;
            }
        }
    }else {
        
        CGFloat contentM = (self.frame.size.height - self.contentView.frame.size.height);
        if (translation.y > 0) { // 向下拖拽
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.y += translation.y;
            self.contentView.frame = contentFrame;
        }else if (translation.y < 0 && self.contentView.frame.origin.y > contentM) { // 向上拖拽
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.y = MAX((self.contentView.frame.origin.y + translation.y), contentM);
            self.contentView.frame = contentFrame;
        }
    }
    
    [panGesture setTranslation:CGPointZero inView:self.contentView];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGesture velocityInView:self.contentView];
        
        self.scrollView.panGestureRecognizer.enabled = YES;
        
        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
        if (velocity.y > 0 && self.lastTransitionY > 5 && !self.isDragScrollView) {
            [self dissMissTap];
        }else {
            [self show];
        }
    }
    
    self.lastTransitionY = translation.y;
}
@end
