//
//  SXShopSayNavView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayNavView.h"

@implementation SXShopSayNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height-36)/2, 36, 36)];
        [self.iconImageView setAllCorner:18];
        self.iconImageView.userInteractionEnabled = YES;
        [self addSubview:self.iconImageView];

        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, DR_SCREEN_WIDTH-150, frame.size.height)];
        self.shopNameL.font = XGSIXBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:self.shopNameL];
        self.shopNameL.text = @"店铺名称";
    }
    return self;
}


- (void)setModel:(SXShopSayListModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.shopModel.shop_avatar_url]];
    self.shopNameL.text = model.shopModel.shop_name;
    self.shopNameL.frame = CGRectMake(44, 0, GET_STRWIDTH(model.shopModel.shop_name, 17, 22), self.frame.size.height);
    //是否有认证
    if (model.shopModel.is_certified.boolValue) {//认证过
        self.markImageView.hidden = NO;
    }
    
    //是否有性别
    if (model.shopModel.sex.intValue) {
        self.sexImageView.hidden = NO;
        if (model.shopModel.is_certified.boolValue) {
            self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.markImageView.frame), (self.frame.size.height-16)/2, 16, 16);
        }else{
            self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.shopNameL.frame), (self.frame.size.height-16)/2, 16, 16);
        }
        self.sexImageView.image = model.shopModel.sex.intValue == 1? UIImageNamed(@"sx_shop_male") : UIImageNamed(@"sx_shop_fale");//sx_shop_fale女
    }
}


- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.shopNameL.frame), (self.frame.size.height-16)/2, 16, 16)];
        _markImageView.image = UIImageNamed(@"sxrenztub_img");
        [self addSubview:_markImageView];
    }
    return _markImageView;
}
- (UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.shopNameL.frame), (self.frame.size.height-16)/2, 16, 16)];
        _sexImageView.image = UIImageNamed(@"sx_shop_male");//sx_shop_fale女
        [self addSubview:_sexImageView];
    }
    return _sexImageView;
}


@end
