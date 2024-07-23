//
//  SXScVideoToAlbumView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXScVideoToAlbumView.h"
#import "SXVideoZjToastListCell.h"
#import "SXAddVideoZjView.h"
@implementation SXScVideoToAlbumView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 438)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_contentView setCornerOnTop:20];
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = @"收藏到专辑";
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_contentView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, DR_SCREEN_WIDTH, _contentView.frame.size.height-50-BOTTOM_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 66;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[SXVideoZjToastListCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        [self createRefesh];
        
        

        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 66)];
        self.tableView.tableHeaderView = headerView;
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addzjClick)];
        [headerView addGestureRecognizer:addTap];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 56)];
        [backView setAllCorner:10];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [headerView addSubview:backView];
        
        UIImageView *_zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-15-20, 18,20,20)];
        _zjImageView.image = UIImageNamed(@"sx_addvideozj_img");
        _zjImageView.userInteractionEnabled = YES;
        [backView addSubview:_zjImageView];
        
        UILabel *_nameL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,150,56)];
        _nameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _nameL.font = XGSIXBoldFontSize;
        _nameL.text = @"新建专辑";
        [backView addSubview:_nameL];
        
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
    }
    return self;
}


- (void)createRefesh{
    
    __weak SXScVideoToAlbumView *ctl = self;

    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = nil;

    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept: @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
         
            [self.tableView reloadData];
         
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoZjToastListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;//self.dataArr.count;
}

- (void)addzjClick{
   
    SXAddVideoZjView *addView = [[SXAddVideoZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];

    addView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
      
//        NSMutableDictionary *parm = [NSMutableDictionary new];
//        
//        if (self.isLimt) {
//            [parm setObject:@"0" forKey:@"bucketId"];
//            [parm setObject:@"0000000000" forKey:@"albumCoverUri"];
//            [parm setObject:name forKey:@"albumName"];
//        }else{
//            [parm setObject:name forKey:@"albumName"];
//            [parm setObject:isOpen?@"1":@"3" forKey:@"albumType"];
//        }
//        
//        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isLimt?@"dialogAlbums": [NSString stringWithFormat:@"user/%@/voiceAlbum",[NoticeTools getuserId]] Accept:self.isLimt?@"application/vnd.shengxi.v4.7.6+json": @"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
//            if (success) {
//                [self.collectionView.mj_header beginRefreshing];
//            }
//            
//            [self hideHUD];
//        } fail:^(NSError * _Nullable error) {
//            [self hideHUD];
//        }];
    };
    [addView show];
   
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
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44);
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
