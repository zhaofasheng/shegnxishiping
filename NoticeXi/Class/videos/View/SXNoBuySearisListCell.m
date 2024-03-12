//
//  SXNoBuySearisListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXNoBuySearisListCell.h"

@implementation SXNoBuySearisListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 50)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setAllCorner:8];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, self.backView.frame.size.width-15-50, 50)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.titleL];
        
        UIImageView *lockImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-20, 15, 20, 20)];
        lockImageV.image = UIImageNamed(@"sxlock_img");
        [self.backView addSubview:lockImageV];
    }
    return self;
}

- (void)setVideoModel:(SXSearisVideoListModel *)videoModel{
    _videoModel = videoModel;
    self.titleL.text = videoModel.title;
    
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
