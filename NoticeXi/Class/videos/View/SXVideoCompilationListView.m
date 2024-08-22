//
//  SXVideoCompilationListView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCompilationListView.h"
#import "SXCompilationCell.h"
#import "SXConfigModel.h"
@interface SXVideoCompilationListView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;

@end

@implementation SXVideoCompilationListView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 557)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_contentView setCornerOnTop:20];
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, DR_SCREEN_WIDTH-100, 22)];
        label.font = XGEightBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_contentView addSubview:label];
        self.titleL = label;
        
        self.numL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 30, 200, 16)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_contentView addSubview:self.numL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, DR_SCREEN_WIDTH, _contentView.frame.size.height-50-BOTTOM_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 90;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[SXCompilationCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];


        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
    
        
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    self.titleL.text = videoModel.compilation_name;
}

- (void)requestList{
    NSString *url = [NSString stringWithFormat:@"video/compilation/%@/%@",[NoticeTools getuserId],self.videoModel.compilation_id];

    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept: @"application/vnd.shengxi.v5.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            SXConfigModel *dataM = [SXConfigModel mj_objectWithKeyValues:dict[@"data"]];
            self.numL.text = [NSString stringWithFormat:@"%d个内容",dataM.countNum.intValue];
            for (NSDictionary *dic in dataM.list) {
                SXVideosModel *model = [SXVideosModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
         
            [self.tableView reloadData];
         
        }
    } fail:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [self dissMissTap];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXCompilationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.videoModel = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (void)show{
    [self requestList];
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height+20, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    [self.tableView reloadData];
}

- (void)dissMissTap{
 
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
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
            UIWindow *rootWindow = [SXTools getKeyWindow];
            [rootWindow addSubview:self];
            [UIView animateWithDuration:0.3 animations:^{
                self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height+20, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            }];
            [self.tableView reloadData];
        }
    }
    
    self.lastTransitionY = translation.y;
}

@end
