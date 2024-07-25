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
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 10, DR_SCREEN_WIDTH-15-115, 112)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setCornerOnRight:8];
        [self addSubview:self.backView];
    

        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,15,self.backView.frame.size.width-15, 44)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_titleL];
        _titleL.numberOfLines = 2;
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(10,77,100, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_markL];
        _markL.numberOfLines = 0;
        
        self.sendButton = [[UIButton  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-72, 70, 72, 32)];
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        self.sendButton.layer.cornerRadius = 16;
        self.sendButton.layer.masksToBounds = YES;
        self.sendButton.layer.borderWidth = 1;
        self.sendButton.titleLabel.font = TWOTEXTFONTSIZE;
        [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendButton setTitle:@"赠送好友" forState:UIControlStateNormal];
        [self.backView addSubview:self.sendButton];
        self.sendButton.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setCardModel:(SXKcCardListModel *)cardModel{
    _cardModel = cardModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.searModel.simple_cover_url]];
    self.titleL.text = cardModel.searModel.series_name;
    if (GET_STRWIDTH(self.titleL.text, 16, 20) > self.titleL.frame.size.width) {
        self.titleL.frame = CGRectMake(10,15,self.backView.frame.size.width-15, 44);
    }else{
        self.titleL.frame = CGRectMake(10,15,self.backView.frame.size.width-15, 22);
    }
    if (!self.isGet) {
        self.sendButton.hidden = NO;
        if (cardModel.card_number.length > 6) {
            self.markL.text = [NSString stringWithFormat:@"仅可赠送(编号%@)",[cardModel.card_number substringFromIndex:cardModel.card_number.length-6]];
        }else{
            self.markL.text = @"仅可赠送";
        }
        
        if (cardModel.give_status.intValue == 1) {
            self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
            [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"#14151A"].CGColor;
            [self.sendButton setTitle:@"赠送好友" forState:UIControlStateNormal];
        }else if (cardModel.give_status.intValue == 2){
            self.sendButton.backgroundColor = [UIColor whiteColor];
            [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
            self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"#14151A"].CGColor;
            [self.sendButton setTitle:@"赠送中" forState:UIControlStateNormal];
        }else if (cardModel.give_status.intValue == 3){
            self.sendButton.backgroundColor = [UIColor whiteColor];
            [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
            self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
            [self.sendButton setTitle:@"已领取" forState:UIControlStateNormal];
        }
    }else{
        self.sendButton.hidden = YES;
        self.markL.text = [NSString stringWithFormat:@"赠送者：%@",cardModel.getUserInfoM.nick_name];
    }
    self.markL.frame = CGRectMake(10,77,GET_STRWIDTH(self.markL.text, 12, 17), 17);
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
