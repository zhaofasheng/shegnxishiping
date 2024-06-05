//
//  SXShopLyStoryCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLyStoryCell.h"

@implementation SXShopLyStoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 107)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [backView setAllCorner:10];
        [self addSubview:backView];
        
        self.orderL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-30-10, 17)];
        self.orderL.font = TWOTEXTFONTSIZE;
        self.orderL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.orderL];
        
        self.iconImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 37, 60, 60)];
        self.iconImageView.userInteractionEnabled = YES;
        [self.iconImageView setAllCorner:4];
        [backView addSubview:self.iconImageView];
        
        self.shopNameL = [[UILabel  alloc] initWithFrame:CGRectMake(80, 43, DR_SCREEN_WIDTH-30-80,21)];
        self.shopNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backView addSubview:self.shopNameL];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(80, 72, DR_SCREEN_WIDTH-30-80,18)];
        self.timeL.font = THRETEENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [backView addSubview:self.timeL];
        
        self.chatTouseBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-80, 51, 80, 32)];
        self.chatTouseBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.chatTouseBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        [self.chatTouseBtn setTitle:@"联系买家" forState:UIControlStateNormal];
        [self.chatTouseBtn setAllCorner:16];
        self.chatTouseBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [backView addSubview:self.chatTouseBtn];
        [self.chatTouseBtn addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)chatClick{
    
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
