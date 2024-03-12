//
//  NoticeEditCardCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditCardCell.h"

@implementation NoticeEditCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 56)];
        [backView setAllCorner:10];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(12, 0,200,56)];
        self.nameL.font = SIXTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.nameL];
        
 
    }
    return self;
}



- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    self.nameL.text = shopModel.myShopM.shop_name;
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
