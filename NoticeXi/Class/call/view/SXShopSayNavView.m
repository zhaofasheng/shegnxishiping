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
    
    //是否有认证
    
    //是否有性别
    

}


- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.shopNameL.frame), 25, 16, 16)];
        _markImageView.image = UIImageNamed(@"sxrenztub_img");
        [self addSubview:_markImageView];
    }
    return _markImageView;
}
- (UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopNameL.frame)+2, 25,16, 16)];
        _sexImageView.image = UIImageNamed(@"sx_shop_male");//sx_shop_fale女
        [self addSubview:_sexImageView];
    }
    return _sexImageView;
}


@end
