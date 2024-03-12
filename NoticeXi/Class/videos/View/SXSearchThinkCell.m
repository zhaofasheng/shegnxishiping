//
//  SXSearchThinkCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/27.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSearchThinkCell.h"

@implementation SXSearchThinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 40)];
        self.titleL.font = FIFTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:self.titleL];
        
        UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(15, 39, DR_SCREEN_WIDTH-15, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self.contentView addSubview:line];
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
