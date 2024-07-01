//
//  SXChoiceVideoToPlayView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/1.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXChoiceVideoToPlayView.h"
#import "SXChoiceVideoToPlayCell.h"

@interface SXChoiceVideoToPlayView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SXChoiceVideoToPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 240, self.frame.size.height)];
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.8];
        [self addSubview:self.contentView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,15,self.contentView.frame.size.width, self.contentView.frame.size.height-30)];
        self.tableView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[SXChoiceVideoToPlayCell class] forCellReuseIdentifier:@"cell"];
        [self.contentView addSubview:self.tableView];
        self.tableView.rowHeight = 44;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searisArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXChoiceVideoToPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SXSearisVideoListModel *model = self.searisArr[indexPath.row];
    cell.nameL.text = model.title;
    if ([model.videoId isEqualToString:self.currentModel.videoId]) {
        cell.nameL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
    }else{
        cell.nameL.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.choiceVideoBlock) {
        self.choiceVideoBlock(self.searisArr[indexPath.row]);
    }
}

- (void)setSearisArr:(NSMutableArray *)searisArr{
    _searisArr = searisArr;
    [self.tableView reloadData];
    
    for (int i = 0; i < searisArr.count; i++) {
        SXSearisVideoListModel *model = searisArr[i];
        if ([model.videoId isEqualToString:self.currentModel.videoId]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            break;
        }
    }
}

- (void)dissMissView{
    self.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(self.frame.size.width, 0, 240, self.frame.size.height);
    }];
}

- (void)show{
    self.hidden = NO;
   
    self.contentView.frame = CGRectMake(self.frame.size.width, 0, 240, self.frame.size.height);
    self.tableView.frame = CGRectMake(0,15,self.contentView.frame.size.width, self.contentView.frame.size.height-30);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(self.frame.size.width-240, 0, 240, self.frame.size.height);
    }];
}


@end
