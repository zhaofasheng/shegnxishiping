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
        _freeImageView.hidden = YES;
        if (goodModel.is_experience.boolValue) {
            self.freeImageView.hidden = NO;
            self.freeLabel.text = [NSString stringWithFormat:@"免费试聊%d次",goodModel.experience_times.intValue];
        }
    }else{
        _buyButton.hidden = YES;
        self.changePriceBtn.hidden = NO;
    }
}

- (UIImageView *)freeImageView{
    if (!_freeImageView) {
        _freeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-108-15, 5, 108, 43)];
        _freeImageView.image = UIImageNamed(@"freeTimes_img");
        [self.contentView addSubview:_freeImageView];
        
        self.freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7,108, 18)];
        self.freeLabel.font = THRETEENTEXTFONTSIZE;
        self.freeLabel.textAlignment = NSTextAlignmentCenter;
        self.freeLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_freeImageView addSubview:self.freeLabel];
    }
    return _freeImageView;
}

- (void)buyClick{
    if (self.buyGoodsBlock) {
        self.buyGoodsBlock(self.goodModel);
    }
}

- (UIButton *)buyButton{
    if(!_buyButton){
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-60-15, 71, 60, 24)];
        _buyButton.layer.cornerRadius = 12;
        _buyButton.layer.masksToBounds = YES;
        _buyButton.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        [_buyButton setTitle:@"下单" forState:UIControlStateNormal];
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
