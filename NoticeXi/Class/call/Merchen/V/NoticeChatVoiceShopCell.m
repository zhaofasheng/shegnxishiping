//
//  NoticeChatVoiceShopCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatVoiceShopCell.h"
#import "NoticeXi-Swift.h"
@implementation NoticeChatVoiceShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 140)];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backV];
        self.backView = backV;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(81, 15, DR_SCREEN_WIDTH-96-60, 20)];
        titleL.font = FOURTHTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backV addSubview:titleL];
        titleL.numberOfLines = 0;
        self.titleL = titleL;
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backV.frame.size.width-15-20, 15, 20, 20)];
        self.choiceImageView.image = UIImageNamed(@"Image_nochoicesh");
        [backV addSubview:self.choiceImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 56, 56)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        [backV addSubview:self.iconImageView];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(81, 45, 200, 30)];
        self.priceL.font = SXNUMBERFONT(22);
        self.priceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [backV addSubview:self.priceL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(81, 39, backV.frame.size.width-81, 17)];
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.text = @"可选服务 | 每位顾客可体验3次";
        [backV addSubview:self.markL];
        
        self.changePriceBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceL.frame)+25, backV.frame.size.width/2, 20)];
        [self.changePriceBtn setTitle:@"修改" forState:UIControlStateNormal];
        [self.changePriceBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.changePriceBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.changePriceBtn setImage:UIImageNamed(@"Image_changevoiceprice") forState:UIControlStateNormal];
        self.changePriceBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [backV addSubview:self.changePriceBtn];
        [self.changePriceBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(backV.frame.size.width/2,CGRectGetMaxY(self.priceL.frame)+25,backV.frame.size.width/2, 20)];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.deleteBtn setImage:UIImageNamed(@"sx_deletegoods") forState:UIControlStateNormal];
        self.deleteBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [backV addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setGoodModel:(NoticeGoodsModel *)goodModel{
    _goodModel = goodModel;
    self.choiceImageView.image = UIImageNamed(goodModel.choice.boolValue?@"Image_choicesh":@"Image_nochoicesh");
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_img_url]];
    
    self.priceL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@鲸币/%@分钟",goodModel.price,goodModel.duration] setSize:12 setLengthString:[NSString stringWithFormat:@"鲸币/%@分钟",goodModel.duration] beginSize:goodModel.price.length];
    
    self.changePriceBtn.hidden = goodModel.is_experience.boolValue?YES:NO;
    self.deleteBtn.hidden = self.changePriceBtn.hidden;
    
    if (goodModel.is_experience.boolValue && !self.isOtherLook) {
        self.markL.hidden = NO;
    }else{
        self.markL.hidden = YES;
    }
    
    _tagL.hidden = YES;
    if (goodModel.is_experience.boolValue && !self.isOtherLook) {
        self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 101);
        self.priceL.frame = CGRectMake(81, 60, 200, 26);
        self.titleL.frame = CGRectMake(81, 15, DR_SCREEN_WIDTH-96-60, 20);

        self.titleL.attributedText = [SXTools getStringWithLineHight:3 string:goodModel.goods_name];;
    }else{
        self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, goodModel.nameHeight+92+15 - (self.noneedEdit?45:0));
        if (goodModel.tagString && !goodModel.is_experience.intValue) {
            self.tagL.hidden = NO;
            self.tagL.text = goodModel.tagString;
            self.tagL.frame = CGRectMake(81, 18, GET_STRWIDTH(goodModel.tagString, 11, 20)+10, 18);
            
            self.titleL.frame = CGRectMake(81, 15, DR_SCREEN_WIDTH-96-60, goodModel.nameHeight);
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:goodModel.goods_name];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:3];
            paragraphStyle.firstLineHeadIndent = GET_STRWIDTH(goodModel.tagString, 11, 20)+10+5;
            [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,goodModel.goods_name.length)];
            self.titleL.attributedText = string1;
        }else{
            self.titleL.attributedText = [SXTools getStringWithLineHight:3 string:goodModel.goods_name];
            self.titleL.frame = CGRectMake(81, 15, DR_SCREEN_WIDTH-96-60, goodModel.nameHeight);
        }
        
        self.priceL.frame = CGRectMake(81,CGRectGetMaxY(self.titleL.frame)+10, 200, 26);
        self.changePriceBtn.frame = CGRectMake(0, CGRectGetMaxY(self.priceL.frame)+25, self.backView.frame.size.width/2, 20);
        self.deleteBtn.frame = CGRectMake(self.backView.frame.size.width/2,CGRectGetMaxY(self.priceL.frame)+25,self.backView.frame.size.width/2, 20);
    }
    
    _changeGoodsBtn.hidden = YES;
    if (self.noneedEdit) {
        self.deleteBtn.hidden = YES;
        self.changePriceBtn.hidden = YES;
        
        if (self.isSelfLook && !goodModel.is_experience.boolValue) {
            self.changeGoodsBtn.hidden = NO;
            self.changeGoodsBtn.frame = CGRectMake(self.backView.frame.size.width-15-56, self.priceL.frame.origin.y-1, 56, 28);
        }
    }
    
    _freeLabel.hidden = YES;
    _buyButton.hidden = YES;
    if (self.noneedEdit && self.isOtherLook) {
        if (goodModel.is_experience.boolValue) {
            self.freeLabel.hidden = NO;
            self.freeLabel.text = [NSString stringWithFormat:@"免费试聊%d次",goodModel.experience_times.intValue];
        }
        self.buyButton.frame = CGRectMake(self.backView.frame.size.width-15-60, self.priceL.frame.origin.y-3, 60, 32);
        self.buyButton.hidden = NO;
    }
    
    if (self.isSelfLook || self.isOtherLook) {
        self.choiceImageView.hidden = YES;
    }
}

- (UIButton *)buyButton{
    if(!_buyButton){
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-60-15, 38, 60, 32)];
        [_buyButton setAllCorner:16];
        //渐变色
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF68A3"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FF3C92"].CGColor];//#FF3C92
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_buyButton.frame), CGRectGetHeight(_buyButton.frame));
        _buyButton.userInteractionEnabled = NO;
        [_buyButton.layer addSublayer:gradientLayer];
        [_buyButton setTitle:@"通话" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.backView addSubview:_buyButton];
    }
    return _buyButton;
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


- (UILabel *)tagL{
    if (!_tagL) {
        _tagL = [[UILabel  alloc] initWithFrame:CGRectMake(81, 15,0, 0)];
        _tagL.backgroundColor = [UIColor colorWithHexString:@"#D8F361"];
        _tagL.font = ELEVENTEXTFONTSIZE;
        _tagL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _tagL.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_tagL];
        _tagL.layer.cornerRadius = 2;
        _tagL.layer.masksToBounds = YES;
    }
    return _tagL;
}

- (UILabel *)changeGoodsBtn{
    if (!_changeGoodsBtn) {
        _changeGoodsBtn = [[UILabel  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-56, self.priceL.frame.origin.y-1, 56, 28)];
        _changeGoodsBtn.layer.cornerRadius = 14;
        _changeGoodsBtn.layer.masksToBounds = YES;
        _changeGoodsBtn.layer.borderColor = [UIColor colorWithHexString:@"#E1E4F0"].CGColor;
        _changeGoodsBtn.layer.borderWidth = 1;
        _changeGoodsBtn.text = @"修改";
        _changeGoodsBtn.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _changeGoodsBtn.font = TWOTEXTFONTSIZE;
        _changeGoodsBtn.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_changeGoodsBtn];
    }
    return _changeGoodsBtn;
}

- (void)changeClick{
 
    if(self.changePriceBlock){
        self.changePriceBlock(self.goodModel);
    }
}

- (void)deleteClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除这个服务吗？" message:nil sureBtn:@"再想想" cancleBtn:@"删除" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            if (weakSelf.deleteBlock) {
                weakSelf.deleteBlock(weakSelf.goodModel);
            }
        }
    };
    [alerView showXLAlertView];
 
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
