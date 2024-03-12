//
//  SXShopCheckTypeCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopCheckTypeCell.h"

@implementation SXShopCheckTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 120)];
        backView.backgroundColor = [UIColor whiteColor];
        [backView setAllCorner:10];
        
        [self.contentView addSubview:backView];
        
        self.typeButton = [[FSCustomButton  alloc] initWithFrame:CGRectMake(0, 33, DR_SCREEN_WIDTH-30, 32)];
        self.typeButton.titleLabel.font = XGEightBoldFontSize;
        [self.typeButton setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        self.typeButton.userInteractionEnabled = NO;
        self.typeButton.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [backView addSubview:self.typeButton];
        
        self.typeL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 69, DR_SCREEN_WIDTH-30, 18)];
        self.typeL.font = THRETEENTEXTFONTSIZE;
        self.typeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.typeL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.typeL];
    }
    return self;
}


- (void)setType:(NSInteger)type{
    _type = type;
    self.typeButton.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 120);
    if (type == 0) {
        self.typeButton.frame = CGRectMake(0, 33, DR_SCREEN_WIDTH-30, 32);
        [self.typeButton setTitle:@"学历认证" forState:UIControlStateNormal];
        [self.typeButton setImage:UIImageNamed(@"sxxuelicheck_img") forState:UIControlStateNormal];
        self.typeL.text = @"可认证本科及以上学历";
    }else if (type == 1){
        [self.typeButton setTitle:@"职业认证" forState:UIControlStateNormal];
        [self.typeButton setImage:UIImageNamed(@"sxworkcheck_img") forState:UIControlStateNormal];
        self.typeL.text = @"";
    }else{
        [self.typeButton setTitle:@"资格证认证" forState:UIControlStateNormal];
        [self.typeButton setImage:UIImageNamed(@"sxzigecheck_img") forState:UIControlStateNormal];
        self.typeL.text = @"";
    }
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
