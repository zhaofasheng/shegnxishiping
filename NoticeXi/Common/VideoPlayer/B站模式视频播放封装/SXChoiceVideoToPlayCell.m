//
//  SXChoiceVideoToPlayCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/1.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXChoiceVideoToPlayCell.h"

@implementation SXChoiceVideoToPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.nameL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 210, 44)];
        self.nameL.font = FIFTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nameL];
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
