//
//  SXAddNewsGoods1Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddNewsGoods1Cell.h"

@implementation SXAddNewsGoods1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 86)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView setAllCorner:10];
        [self.contentView addSubview:self.backView];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 33, 120, 20)];
        markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        markL.font = XGFourthBoldFontSize;
        markL.attributedText = [DDHAttributedMode setColorString:@"*商品图片" setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:@"*" beginSize:0];
        [self.backView addSubview:markL];
        
        self.goodsImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-31-56, 15, 56, 56)];
        [self.goodsImageView setAllCorner:4];
        self.goodsImageView.userInteractionEnabled = YES;
        [self.backView addSubview:self.goodsImageView];
        
        UIImageView *intoImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-16, 35, 16, 16)];
        intoImageV.image = UIImageNamed(@"sx_changegoodsimg");
        intoImageV.userInteractionEnabled = YES;
        [self.backView addSubview:intoImageV];
    }
    return self;
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
