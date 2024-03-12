//
//  NoticeScroEmtionView.m
//  NoticeXi
//
//  Created by li lei on 2020/12/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeScroEmtionView.h"
#import "NoticeEmotionButtonCell.h"
#import "SPMultipleSwitch.h"
@implementation NoticeScroEmtionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,frame.size.height-40-BOTTOM_HEIGHT)];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*2, 0);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        __weak typeof(self) weakSelf = self;
        self.emotionView  = [[NoticeEmotionView alloc] initWithNoHot];
        self.emotionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.emotionView.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(url, buckId, pictureId, isHot);
            }
        };
        self.emotionView.addMoreBlock = ^(BOOL addMore) {
            if (weakSelf.pushBlock) {
                weakSelf.pushBlock(YES);
            }
        };

        [self.scrollView addSubview:self.emotionView];
        
        self.hotEmotionView  = [[NoticeEmotionView alloc] initWithHot];
        self.hotEmotionView.frame = CGRectMake(DR_SCREEN_WIDTH,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.hotEmotionView.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.hotEmotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(url, buckId, pictureId, isHot);
            }
        };
        self.hotEmotionView.collectBlock = ^(BOOL collect) {
            [weakSelf.emotionView.collectionView.mj_header beginRefreshing];
        };
        [self.scrollView addSubview:self.hotEmotionView];
//
        self.buttonArr = [[NSMutableArray alloc] init];

        
        for (int i = 0; i < 2; i++) {
            NoticeEmotionModel *model = [[NoticeEmotionModel alloc] init];
            model.isChoice = i==0?YES:NO;
            model.localImg = i == 0?@"Image_selfemoti_b":@"Image_choicehot";
            [self.buttonArr addObject:model];
            if(i == 0){
                self.oldModel = model;
            }
        }
        
        [self.movieTableView reloadData];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(30,frame.size.height-40-BOTTOM_HEIGHT, DR_SCREEN_WIDTH-60,40);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeEmotionButtonCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 70;
        [self addSubview:self.movieTableView];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"getCategory" Accept:@"application/vnd.shengxi.v5.5.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NSInteger i = 2;
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeEmotionModel *model = [NoticeEmotionModel mj_objectWithKeyValues:dic];
                    
                    NoticeEmotionView *typeEmotionView  = [[NoticeEmotionView alloc] initWithCu];
                    typeEmotionView.cateId = model.pictureId;
                    [typeEmotionView.collectionView.mj_header beginRefreshing];
                    typeEmotionView.frame = CGRectMake(DR_SCREEN_WIDTH*i,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
                    typeEmotionView.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
                    typeEmotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
                        if (weakSelf.sendBlock) {
                            weakSelf.sendBlock(url, buckId, pictureId, isHot);
                        }
                    };
                    typeEmotionView.collectBlock = ^(BOOL collect) {
                        [weakSelf.emotionView.collectionView.mj_header beginRefreshing];
                    };
                    [weakSelf.scrollView addSubview:typeEmotionView];
                    
                    [weakSelf.buttonArr addObject:model];
                    i++;
                }
            
                [weakSelf.movieTableView reloadData];
                weakSelf.scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*weakSelf.buttonArr.count, 0);
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
    return self;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.oldModel.isChoice = NO;
    NoticeEmotionModel *model = self.buttonArr[indexPath.row];
    model.isChoice = YES;
    self.oldModel = model;
    [self.movieTableView reloadData];
    
    self.scrollView.contentOffset = CGPointMake(DR_SCREEN_WIDTH*indexPath.row,0);
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.movieTableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeEmotionButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.buttonModel = self.buttonArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buttonArr.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;

    self.oldModel.isChoice = NO;
    NoticeEmotionModel *model = self.buttonArr[page];
    model.isChoice = YES;
    self.oldModel = model;
    [self.movieTableView reloadData];
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:page inSection:0];
    [self.movieTableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


- (void)refreshEmotion{
    self.emotionView.isDown = YES;
    [self.emotionView requestEmotion];
}

@end
