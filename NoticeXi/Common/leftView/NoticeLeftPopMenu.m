//
//  NoticeLeftPopMenu.m
//  NoticeXi
//
//  Created by li lei on 2023/10/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeLeftPopMenu.h"
#import "NoticePopMenuCell.h"
@interface NoticeLeftPopMenu()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NoticeAbout *numberAbout;
@end

@implementation NoticeLeftPopMenu

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(-DR_SCREEN_WIDTH+70, 0, DR_SCREEN_WIDTH-70, DR_SCREEN_HEIGHT)];
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-70,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[NoticePopMenuCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-70, 0, 70, DR_SCREEN_HEIGHT)];
        [closeButton addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.contentView.frame = CGRectMake(-DR_SCREEN_WIDTH+70, 0, DR_SCREEN_WIDTH-70, DR_SCREEN_HEIGHT);
    [self removeFromSuperview];
    if (indexPath.row == 3) {
        self.numberAbout.existNewHtml = @"0";
        [self.tableView reloadData];
    }
    if(self.choiceIndexBlock){
        self.choiceIndexBlock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 4){
        return 80+10;
    }
    return (DR_SCREEN_WIDTH-90)*135/285+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticePopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.numberModel = self.numberAbout;
    cell.index = indexPath.row;
    return cell;
}

- (void)closePop{
    
    [UIView animateKeyframesWithDuration:0.25//动画持续时间
                                   delay:0//动画延迟执行的时间
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced//动画的过渡效果
                              animations:^{
        self.contentView.frame = CGRectMake(-DR_SCREEN_WIDTH+70, 0, DR_SCREEN_WIDTH-70, DR_SCREEN_HEIGHT);
    }
                              completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showPopMenu{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [rootWindow bringSubviewToFront:self];
    [UIView animateKeyframesWithDuration:0.35//动画持续时间
                                   delay:0//动画延迟执行的时间
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced//动画的过渡效果
                              animations:^{
        self.contentView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-70, DR_SCREEN_HEIGHT);
    }
                              completion:nil];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"todayData" Accept:@"application/vnd.shengxi.v5.5.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
  
        if (success) {
            NoticeAbout *dateModel = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.numberAbout = dateModel;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
    
}

- (void)fastPopMenu{
    self.contentView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-70, DR_SCREEN_HEIGHT);
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [rootWindow bringSubviewToFront:self];
}
@end
