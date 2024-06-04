//
//  SXShopLikelistCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLikelistCell.h"
#import "SXGoodsTimeCell.h"

@implementation SXShopLikelistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0,DR_SCREEN_WIDTH-30, 185)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor = [UIColor whiteColor];
    

        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 72, 72)];
        self.iconImageView.layer.cornerRadius = 8;
        self.iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.iconImageView];
        self.iconImageView.image = UIImageNamed(@"noImage_jynohe");
        self.iconImageView.userInteractionEnabled = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(97, 15, 0,22)];
        self.nickNameL.font = SIXTEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.nickNameL];
        self.nickNameL.textAlignment = NSTextAlignmentCenter;
        self.nickNameL.text = @"用户昵称";
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(97, 101, self.backView.frame.size.width-97-15, 42)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.contentL.numberOfLines = 2;
        [self.backView addSubview:self.contentL];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(97,73,self.backView.frame.size.width-97, 18);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[SXGoodsTimeCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.backView addSubview:self.movieTableView];
        self.movieTableView.scrollEnabled = NO;
        
        self.callView = [[UIView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-100, self.backView.frame.size.height-32, 100, 32)];
        [self.backView addSubview:self.callView];
        
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFA2CC"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FF60B3"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.callView.frame), CGRectGetHeight(self.callView.frame));
        [self.callView.layer addSublayer:gradientLayer];
        [self.callView setCornerOnTopLeft:20];
        

        self.moneyL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.callView.frame.size.width, 32)];
        self.moneyL.font = SXNUMBERFONT(20);
        self.moneyL.textAlignment = NSTextAlignmentCenter;
        self.moneyL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.callView addSubview:self.moneyL];
        
        self.markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+1, self.nickNameL.frame.origin.y+1, 20, 20)];
        self.markImageView.image = UIImageNamed(@"sxrenztub_img");
        [self.backView addSubview:self.markImageView];
        self.markImageView.hidden = YES;
        
        self.sexImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+2, self.nickNameL.frame.origin.y+1, 20, 20)];
        self.sexImageView.image = UIImageNamed(@"sx_shop_male");//sx_shop_fale女
        [self.backView addSubview:self.sexImageView];
    }
    return self;
}


- (void)setShopM:(NoticeMyShopModel *)shopM{
    _shopM = shopM;
    
    self.nickNameL.text = shopM.shop_name;
    
    self.nickNameL.frame = CGRectMake(97, 15, GET_STRWIDTH(self.nickNameL.text, 16, 16), 22);
    
    if (shopM.is_certified.intValue > 0) {
        self.markImageView.hidden = NO;
        self.markImageView.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+1, self.nickNameL.frame.origin.y+1, 20, 20);
        self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.markImageView.frame)+2, self.nickNameL.frame.origin.y+1, 20, 20);
    }else{
        self.markImageView.hidden = YES;
        self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+2, self.nickNameL.frame.origin.y+1, 20, 20);
    }
    
    self.sexImageView.image = shopM.sex.intValue == 2 ? UIImageNamed(@"sx_shop_fale") : UIImageNamed(@"sx_shop_male");
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopM.shop_avatar_url] placeholderImage:UIImageNamed(@"sxshopdefaulticon_img")];
    
    self.callView.hidden = NO;
    NSString *allStr = [NSString stringWithFormat:@"%@鲸币起",shopM.min_price];
    NSString *money = shopM.min_price;
    self.moneyL.attributedText = [DDHAttributedMode setString:allStr setSize:12 setLengthString:@"鲸币起" beginSize:money.length];
    
    if (shopM.tale) {
        self.contentL.text = shopM.tale;
    }else{
        self.contentL.text = @"";
    }
    if (self.shopM.categoryNameArr.count) {
        [self.movieTableView reloadData];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXGoodsInfoModel *cataM = self.shopM.categoryNameArr[indexPath.row];
    return cataM.cateWidth+8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXGoodsTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.cateModel = self.shopM.categoryNameArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopM.categoryNameArr.count;
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
