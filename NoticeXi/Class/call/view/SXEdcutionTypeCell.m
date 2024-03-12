//
//  SXEdcutionTypeCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXEdcutionTypeCell.h"

@implementation SXEdcutionTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        

        self.edcL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-30, 56)];
        self.edcL.font = XGSIXBoldFontSize;
        self.edcL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:self.edcL];
        
        self.changePriceBtn = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-20, 18, 20, 20)];
        self.changePriceBtn.image = UIImageNamed(@"Image_nochoicesh");
        [self.contentView addSubview:self.changePriceBtn];
        self.changePriceBtn.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setEdu:(NSString *)edu{
    _edu = edu;
    self.edcL.text = edu;
    if ([edu isEqualToString:self.currentEdu]) {
        self.changePriceBtn.image = UIImageNamed(@"Image_choicesh");
    }else{
        self.changePriceBtn.image = UIImageNamed(@"Image_nochoicesh");
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
