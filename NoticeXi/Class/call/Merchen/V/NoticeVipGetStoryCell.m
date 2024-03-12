//
//  NoticeVipGetStoryCell.m
//  NoticeXi
//
//  Created by li lei on 2023/9/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipGetStoryCell.h"

@implementation NoticeVipGetStoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
       
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, DR_SCREEN_WIDTH-40,92)];
        backView.backgroundColor = [UIColor whiteColor];
        [backView setAllCorner:10];
        [self.contentView addSubview:backView];
        
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 52)];
        self.cardImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cardImageView.clipsToBounds = YES;
        self.cardImageView.image = UIImageNamed(@"getvipstory_img");
        [backView addSubview:self.cardImageView];
        
    
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(103, 40,backView.frame.size.width-103, 17)];
        self.numberL.font = TWOTEXTFONTSIZE;
        self.numberL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.numberL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(103, 61,backView.frame.size.width-103, 16)];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.timeL];
        
        self.titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(103, 15,backView.frame.size.width-103, 20)];
        self.titleL.font = FIFTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.titleL];
    }
    return self;
}

- (void)setVipModel:(NoticeVipDataModel *)vipModel{
    _vipModel = vipModel;
    self.titleL.text = vipModel.title;
    self.numberL.text = [NSString stringWithFormat:@"%@%@",vipModel.contribute_score,[NoticeTools chinese:@"贡献值" english:@"Points" japan:@"貢献ポイント"]];
    self.timeL.text = vipModel.created_at;
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
