//
//  NoticeShopTagsCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopTagsCell.h"

@implementation NoticeShopTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.addtagsButton = [[UIButton  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 56)];
        [self.addtagsButton setImage:UIImageNamed(@"editAddshop_img") forState:UIControlStateNormal];
        [self.addtagsButton setAllCorner:8];
        self.addtagsButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.addtagsButton];
        
        [self.addtagsButton addTarget:self action:@selector(editInfoClick) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return self;
}


- (void)editInfoClick{
    if (self.editShopModelBlock) {
        self.editShopModelBlock(YES);
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
