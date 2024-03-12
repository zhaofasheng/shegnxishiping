//
//  NoticeJieYouShopHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouShopHeaderView.h"
#import "NoticeShopForLabelcomCell.h"
@implementation NoticeJieYouShopHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.photosWall.hidden = NO;
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = self.backgroundColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeShopForLabelcomCell class] forCellReuseIdentifier:@"cell1"];
        self.tableView.rowHeight = 28+15;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0,self.frame.size.height-(28+15), DR_SCREEN_WIDTH/2,(28+15));
    }
    return self;
}

- (void)setLabelArr:(NSMutableArray *)labelArr{
    _labelArr = labelArr;
    if(_labelArr.count){
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        NSInteger heightCount = labelArr.count;
        if (labelArr.count>=3) {
            heightCount = 3;
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }else{
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
      
        }
        self.tableView.frame = CGRectMake(0,self.frame.size.height-(28+15)*heightCount, DR_SCREEN_WIDTH/2,(28+15)*heightCount);
    }else{
        self.tableView.hidden = YES;
    }
}

- (void)autoScroll{

    if (self.tableView.contentOffset.y >= 43*(self.labelArr.count-3)) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:false];
    }else{
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+43) animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopForLabelcomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.model = _labelArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _labelArr.count;
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    self.photosWall.hidden = shopModel.myShopM.photowallArr.count?NO:YES;
    self.photosWall.photos = shopModel.myShopM.photowallArr;
}

- (NoticeShopPhotosWall *)photosWall{
    if (!_photosWall) {
        _photosWall = [[NoticeShopPhotosWall  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/2, self.frame.size.height-15-40-2, DR_SCREEN_WIDTH/2, 40+2)];
        _photosWall.canChoice = YES;
        __weak typeof(self) weakSelf = self;
        _photosWall.choiceUrlBlock = ^(NSString * _Nonnull choiceUrl) {
            if (weakSelf.choiceUrlBlock) {
                weakSelf.choiceUrlBlock(choiceUrl);
            }
        };
        [self addSubview:_photosWall];
    }
    return _photosWall;
}
@end
