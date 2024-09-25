//
//  SXBuySeriesTypeTools.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuySeriesTypeTools.h"

@implementation SXBuySeriesTypeTools

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(0, (frame.size.height-50)/2, frame.size.width, 21)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleL];
        
        self.priceL = [[UILabel  alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleL.frame)+4, frame.size.width, 25)];
        self.priceL.font = XGTwentyTwoBoldFontSize;
        self.priceL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.priceL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.priceL];
        
        self.oricePriceL = [[UILabel  alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        self.oricePriceL.textAlignment = NSTextAlignmentCenter;
        self.oricePriceL.font = ELEVENTEXTFONTSIZE;
        self.oricePriceL.textColor = [UIColor whiteColor];
        self.oricePriceL.hidden = YES;
        [self addSubview:self.oricePriceL];
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)typeClick:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (self.typeClickBlock) {
        self.typeClickBlock(tapV.tag);
    }
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FF4B98"] colorWithAlphaComponent:0.1];
        self.layer.borderColor = [UIColor colorWithHexString:@"#FF4B98"].CGColor;
        self.layer.borderWidth = 2;
        if (!self.oricePriceL.hidden) {
            self.oricePriceL.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
            self.oricePriceL.textColor = [UIColor whiteColor];
        }
    }else{
        self.layer.borderWidth = 0;
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
        if (!self.oricePriceL.hidden) {
            self.oricePriceL.backgroundColor = [UIColor colorWithHexString:@"#FDEDD5"];
            self.oricePriceL.textColor = [UIColor colorWithHexString:@"#A46910"];
        }
    }
}

@end
