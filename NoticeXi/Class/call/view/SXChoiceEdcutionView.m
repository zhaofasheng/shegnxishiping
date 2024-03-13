//
//  SXChoiceEdcutionView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXChoiceEdcutionView.h"
#import "SXEdcutionTypeCell.h"
@implementation SXChoiceEdcutionView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,419)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.contentView];
        [self.contentView setCornerOnTop:20];
        self.contentView.userInteractionEnabled = YES;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        self.closeBtn = closeBtn;
        [self.closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.dataArr = @[@"本科在读",@"本科",@"硕士在读",@"硕士",@"博士在读",@"博士"];
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 56;
        self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, self.contentView.frame.size.height-50-BOTTOM_HEIGHT);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        [self.tableView registerClass:[SXEdcutionTypeCell class] forCellReuseIdentifier:@"cell"];
        
        [self.tableView reloadData];

        // 添加点击手势
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
               
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
        

    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.edcBlock) {
        self.edcBlock(self.dataArr[indexPath.row],indexPath.row+1);
    }
    [self closeClick];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXEdcutionTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentEdu = self.currenEdc;
    cell.edu = self.dataArr[indexPath.row];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (void)closeClick{

    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    
    [self.tableView reloadData];
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
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
    if (gestureRecognizer == self.tapGesture) {
        CGPoint point = [gestureRecognizer locationInView:self.contentView];
        if ([self.contentView.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    }else if (gestureRecognizer == self.panGesture) {
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
            [self closeClick];
        }else {
            [self show];
        }
    }
    
    self.lastTransitionY = translation.y;
}

@end
