//
//  SXkcCardListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXkcCardListCell.h"

@implementation SXkcCardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 0, 100, 133)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        self.coverImageView.backgroundColor = [UIColor blueColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 10, DR_SCREEN_WIDTH-15-115, 112)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setCornerOnRight:8];
        [self addSubview:self.backView];
    

        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,15,self.backView.frame.size.width-15, 44)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_titleL];
        _titleL.numberOfLines = 2;
        _titleL.text = @"INTP的情感课课程标题标题标 哈哈哈哈";
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(10,77,100, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.text = @"仅可赠送";
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_markL];
        _markL.numberOfLines = 0;
        
        self.sendButton = [[UIButton  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-72, 70, 72, 32)];
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        self.sendButton.layer.cornerRadius = 16;
        self.sendButton.layer.masksToBounds = YES;
        self.sendButton.titleLabel.font = TWOTEXTFONTSIZE;
        [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendButton setTitle:@"赠送好友" forState:UIControlStateNormal];
        [self.backView addSubview:self.sendButton];
    }
    return self;
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
