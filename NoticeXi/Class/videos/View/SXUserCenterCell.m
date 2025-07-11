//
//  SXUserCenterCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserCenterCell.h"

@implementation SXUserCenterCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 64)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.titleImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 20, 24, 24)];
        self.titleImageView.image = UIImageNamed(@"sxwallect_img");
        [self.backView addSubview:self.titleImageView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(48,22,self.backView.frame.size.width-48-100, 21)];
        _titleL.font = XGFifthBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:_titleL];
        
        UIImageView *intoImgView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-20, 22, 20, 20)];
        intoImgView.image = UIImageNamed(@"celljiacunextbtn");
        [self.backView addSubview:intoImgView];
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
