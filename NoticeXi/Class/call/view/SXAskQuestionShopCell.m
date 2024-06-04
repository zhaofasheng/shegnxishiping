//
//  SXAskQuestionShopCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAskQuestionShopCell.h"
#import "SXGoodsTimeCell.h"
@implementation SXAskQuestionShopCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor = [UIColor whiteColor];
    

        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.backView.frame.size.width-72)/2,32, 72, 72)];
        self.iconImageView.layer.cornerRadius = 36;
        self.iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.iconImageView];
        self.iconImageView.image = UIImageNamed(@"noImage_jynohe");
        self.iconImageView.userInteractionEnabled = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+8, self.backView.frame.size.width,22)];
        self.nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.nickNameL];
        self.nickNameL.textAlignment = NSTextAlignmentCenter;
        self.nickNameL.text = @"用户昵称";
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(5, 152, self.backView.frame.size.width-10, 38)];
        self.contentL.font = THRETEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.contentL.numberOfLines = 0;
        [self.backView addSubview:self.contentL];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(5,CGRectGetMaxY(self.contentView.frame)+10,self.backView.frame.size.width-30, 18);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[SXGoodsTimeCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.backView addSubview:self.movieTableView];
        
        self.callView = [[UIView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width/2-20, self.backView.frame.size.height-32, self.backView.frame.size.width/2+20, 32)];
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
        
        self.markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 54, 18)];
        self.markImageView.image = UIImageNamed(@"sxrenztub_img1");
        [self.backView addSubview:self.markImageView];
        self.markImageView.hidden = YES;
        
        self.sexImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+2, self.nickNameL.frame.origin.y+3, 16, 16)];
        self.sexImageView.image = UIImageNamed(@"sx_shop_male");//sx_shop_fale女
        [self.backView addSubview:self.sexImageView];
    }
    return self;
}

- (void)setShopM:(NoticeMyShopModel *)shopM{
    _shopM = shopM;
    
    self.nickNameL.text = shopM.shop_name;
    self.sexImageView.image = shopM.sex.intValue == 2 ? UIImageNamed(@"sx_shop_fale") : UIImageNamed(@"sx_shop_male");
    self.nickNameL.frame = CGRectMake((self.backView.frame.size.width-18-GET_STRWIDTH(self.nickNameL.text, 15, 22))/2, CGRectGetMaxY(self.iconImageView.frame)+8, GET_STRWIDTH(self.nickNameL.text, 15, 22), 22);
    self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+2, self.nickNameL.frame.origin.y+3, 16, 16);
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopM.shop_avatar_url] placeholderImage:UIImageNamed(@"sxshopdefaulticon_img")];
    
    if (self.isFree) {//体验版
        self.callView.hidden = YES;
    }else{
        self.callView.hidden = NO;
        self.timeL.text = [NSString stringWithFormat:@"%@分钟",shopM.goodsM.duration];
        NSString *allStr = [NSString stringWithFormat:@"%@鲸币起",shopM.min_price];
        NSString *money = shopM.min_price;
        self.moneyL.attributedText = [DDHAttributedMode setString:allStr setSize:12 setLengthString:@"鲸币起" beginSize:money.length];
    }
    
    if (shopM.tale) {
        CGFloat height = GET_STRHEIGHT(shopM.tale, 13, self.backView.frame.size.width-10);
        if (height > 38) {
            height = 38;
        }
        self.contentL.frame = CGRectMake(5, CGRectGetMaxY(self.nickNameL.frame)+4, self.backView.frame.size.width-10, height);
        self.contentL.text = shopM.tale;
        self.movieTableView.frame =  self.movieTableView.frame = CGRectMake(5,CGRectGetMaxY(self.contentL.frame)+10,self.backView.frame.size.width-10, 18);
    }else{
        self.movieTableView.frame = CGRectMake(5,CGRectGetMaxY(self.nickNameL.frame)+10,self.backView.frame.size.width-10, 18);
    }
  
    if (shopM.is_certified.intValue > 0) {
        self.markImageView.hidden = NO;
    }else{
        self.markImageView.hidden = YES;
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

@end
