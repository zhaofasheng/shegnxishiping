//
//  SXAddNewsGoods4Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddNewsGoods4Cell.h"
#import "SXGoodsTimeCell.h"
@implementation SXAddNewsGoods4Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 106)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView setAllCorner:10];
        [self.contentView addSubview:self.backView];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 120, 20)];
        markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        markL.font = XGFourthBoldFontSize;
        markL.attributedText = [DDHAttributedMode setColorString:@"*时长" setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:@"*" beginSize:0];
        [self.backView addSubview:markL];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(15,50,self.backView.frame.size.width-30, 40);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[SXGoodsTimeCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 88+20;
        self.movieTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.backView addSubview:self.movieTableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXGoodsTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
