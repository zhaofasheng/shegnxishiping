//
//  NoticeChoiceJieyouChatCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceJieyouChatCell.h"

@implementation NoticeChoiceJieyouChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 108)];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backV];
        self.backView = backV;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(85, 15,backV.frame.size.width-85-35, 22)];
        titleL.font = XGSIXBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backV addSubview:titleL];
        self.titleL = titleL;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        self.iconImageView.layer.cornerRadius = 2;
        self.iconImageView.layer.masksToBounds = YES;
        [backV addSubview:self.iconImageView];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(85, 68, 200, 30)];
        self.priceL.font = SXNUMBERFONT(22);
        self.priceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [backV addSubview:self.priceL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(85, 41, backV.frame.size.width-81, 17)];
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.text = @"仅支持连麦 | 聊天记录不保存";
        [backV addSubview:self.markL];
        
        self.changePriceBtn = [[UIImageView alloc] initWithFrame:CGRectMake(backV.frame.size.width-15-20, 15, 20, 20)];
        self.changePriceBtn.image = UIImageNamed(@"Image_changevoiceprice");
        [backV addSubview:self.changePriceBtn];
    }
    return self;
}

- (void)setGoodModel:(NoticeGoodsModel *)goodModel{
    _goodModel = goodModel;

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_img_url]];
    
    self.markL.text = goodModel.is_experience.boolValue?@"每位顾客可体验3次" : @"固定时长 | 自定义价格";
    self.titleL.text = goodModel.goods_name;
    
    NSString *str1 = [NSString stringWithFormat:@"%@",goodModel.price];
    NSString *str2 = [NSString stringWithFormat:@"鲸币/%@分钟",goodModel.duration];
    self.priceL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",str1,str2] setSize:12 setLengthString:str2 beginSize:str1.length];
    
    if (self.isUserLookShop) {
        self.changePriceBtn.hidden = YES;
        self.buyButton.hidden = NO;
        self.markL.text = @"";
        _freeLabel.hidden = YES;
        if (goodModel.is_experience.boolValue) {
            self.freeLabel.text = [NSString stringWithFormat:@"免费试聊%d次",goodModel.experience_times.intValue];
        }
        _titleL.frame = CGRectMake(85, 25, self.backView.frame.size.width-85-35, 22);
        self.iconImageView.frame = CGRectMake(15, 24, 60, 60);
        self.priceL.frame = CGRectMake(85, CGRectGetMaxY(_titleL.frame)+10, self.priceL.frame.size.width, self.priceL.frame.size.height);
    }else{
        _buyButton.hidden = YES;
        self.changePriceBtn.hidden = NO;
    }
}

- (UILabel *)freeLabel{
    if (!_freeLabel) {
     
        _freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-90, 0,90, 20)];
        _freeLabel.font = ELEVENTEXTFONTSIZE;
        [_freeLabel setTopRightAndbottomLeftCorner:10];
        _freeLabel.textAlignment = NSTextAlignmentCenter;
        _freeLabel.backgroundColor = [UIColor colorWithHexString:@"#D8F361"];
        _freeLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_freeLabel];
    }
    return _freeLabel;
}

- (void)buyClick{
    if (self.buyGoodsBlock) {
        self.buyGoodsBlock(self.goodModel);
    }
}

- (UIButton *)buyButton{
    if(!_buyButton){
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-60-15, 38, 60, 32)];
        [_buyButton setAllCorner:16];
        _buyButton.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        [_buyButton setTitle:@"通话" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.backView addSubview:_buyButton];
        [_buyButton addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
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
