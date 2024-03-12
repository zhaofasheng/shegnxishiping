//
//  SXSetCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSetCell.h"

@implementation SXSetCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 52)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        self.backView = backView;
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,backView.frame.size.width-48-100, 52)];
        _titleL.font = XGFifthBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_titleL];
        
        UIImageView *intoImgView = [[UIImageView  alloc] initWithFrame:CGRectMake(backView.frame.size.width-15-20, 16, 20, 20)];
        intoImgView.image = UIImageNamed(@"cellnextbutton");
        [self.backView addSubview:intoImgView];
        intoImgView.userInteractionEnabled = YES;
        self.subImageV = intoImgView;
     
        _subL = [[UILabel alloc] initWithFrame:CGRectMake(85,0,DR_SCREEN_WIDTH-35-30-15-85, 52)];
        _subL.font = FOURTHTEENTEXTFONTSIZE;
        _subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _subL.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:_subL];
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
