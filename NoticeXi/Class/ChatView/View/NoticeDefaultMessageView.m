//
//  NoticeDefaultMessageView.m
//  NoticeXi
//
//  Created by li lei on 2020/8/7.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeDefaultMessageView.h"

@implementation NoticeDefaultMessageView
{
    BOOL _isShowImg;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44+BOTTOM_HEIGHT)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, _contentView.frame.size.height-44-BOTTOM_HEIGHT, DR_SCREEN_WIDTH-40, 40)];
        button.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [button setTitle:[NoticeTools chinese:@"编辑" english:@"Edit" japan:@"変更"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(dissMissTaps) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
  
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/2*i, 0, DR_SCREEN_WIDTH/2, 18+38)];
            [btn setTitle:i==0?[NoticeTools getLocalStrWith:@"group.imgs"]:[NoticeTools getLocalStrWith:@"search.voice"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if ( i == 1) {
                self.voiceBtn = btn;
                [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
            }else{
                self.imgBtn = btn;
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,18+38+2, DR_SCREEN_WIDTH, _contentView.frame.size.height-58-8-44-BOTTOM_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];

        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-_contentView.frame.size.height)];
        tapView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissTap)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
  
    }
    return self;
}

- (void)choiceClick:(UIButton *)btn{
    _isShowImg = btn.tag == 0?YES:NO;
    [self.tableView reloadData];
    if (btn.tag == 0) {
        [self.voiceBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        self.voiceBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.imgBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.imgBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    }else{
        [self.imgBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        self.imgBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.voiceBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.voiceBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    }
}

- (void)show{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(263+44+44+BOTTOM_HEIGHT), DR_SCREEN_WIDTH, 263+44+44+BOTTOM_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
    
}

- (void)dissMissTaps{
    self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44+BOTTOM_HEIGHT);
    self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(setYuseClick)]) {
        [self.delegate setYuseClick];
    }
}

- (void)dissMissTap{

    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44+BOTTOM_HEIGHT);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _isShowImg?self.imgArr.count: self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    cell.textLabel.font = FOURTHTEENTEXTFONTSIZE;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH,40);
    NoticeYuSetModel *model = _isShowImg?self.imgArr[indexPath.row]:self.dataArr[indexPath.row];
    cell.textLabel.text = model.reply_remark;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeYuSetModel *model = _isShowImg?self.imgArr[indexPath.row]:self.dataArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageWithDefault:)]) {
        [self.delegate sendMessageWithDefault:model];
    }
    [self dissMissTap];
}
@end
