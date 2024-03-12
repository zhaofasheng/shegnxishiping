//
//  SXAskQuestionShopCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAskQuestionShopCell.h"

@implementation SXAskQuestionShopCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor = [UIColor whiteColor];
        
        self.tagView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, 30)];
        self.tagView.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.backView addSubview:self.tagView];
        self.tagView.hidden = YES;
        
        self.tagL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 0, self.tagView.frame.size.width-15, 30)];
        self.tagL.font = ELEVENTEXTFONTSIZE;
        self.tagL.textColor = [UIColor whiteColor];
        [self.tagView addSubview:self.tagL];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.backView.frame.size.width-72)/2,40, 72, 72)];
        self.iconImageView.layer.cornerRadius = 36;
        self.iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.iconImageView];
        self.iconImageView.image = UIImageNamed(@"noImage_jynohe");
        self.iconImageView.userInteractionEnabled = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.backView.frame.size.width,22)];
        self.nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.nickNameL];
        self.nickNameL.textAlignment = NSTextAlignmentCenter;
        self.nickNameL.text = @"用户昵称";
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(5, 152, self.backView.frame.size.width-10, 54)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.contentL.numberOfLines = 0;
        [self.backView addSubview:self.contentL];
        
        self.callView = [[UIView  alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height-45, self.backView.frame.size.width, 45)];
        [self.backView addSubview:self.callView];
        
        UIImageView *callImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 17, 12, 12)];
        callImageV.image = UIImageNamed(@"sxcallimg_img");
        [self.callView addSubview:callImageV];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, (self.callView.frame.size.width-20)/2-26, 45)];
        self.timeL.font = XGELEVENBoldFontSize;
        self.timeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.callView addSubview:self.timeL];
        
        self.moneyL = [[UILabel alloc] initWithFrame:CGRectMake(self.callView.frame.size.width/2, 0, self.callView.frame.size.width/2-10, 45)];
        self.moneyL.font = SXNUMBERFONT(22);
        self.moneyL.textAlignment = NSTextAlignmentRight;
        self.moneyL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.callView addSubview:self.moneyL];
        
    
    }
    return self;
}

- (void)setShopM:(NoticeMyShopModel *)shopM{
    _shopM = shopM;
    
    self.nickNameL.text = shopM.shop_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopM.shop_avatar_url] placeholderImage:UIImageNamed(@"sxshopdefaulticon_img")];
    
    if (shopM.goodsM.is_experience.intValue) {//体验版
        self.callView.hidden = YES;
    }else{
        self.callView.hidden = NO;
        self.timeL.text = [NSString stringWithFormat:@"%@分钟",shopM.goodsM.duration];
        NSString *allStr = [NSString stringWithFormat:@"%@鲸币",shopM.goodsM.price];
        NSString *money = shopM.goodsM.price;
        self.moneyL.attributedText = [DDHAttributedMode setString:allStr setSize:12 setLengthString:@"鲸币" beginSize:money.length];
    }
}

@end
