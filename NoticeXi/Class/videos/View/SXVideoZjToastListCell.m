//
//  SXVideoZjToastListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoZjToastListCell.h"

@implementation SXVideoZjToastListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 56)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView setAllCorner:10];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, self.backView.frame.size.width-15-60, 56)];
        self.titleL.font = XGSIXBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.titleL];
        self.titleL.text = @"视频专辑";
        
        self.numL = [[UILabel  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-45, 0, 45, 56)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textAlignment = NSTextAlignmentRight;
        self.numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.numL];
        self.numL.text = @"0";
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
