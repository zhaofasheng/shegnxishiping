//
//  NoticeShopStroyCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopStroyCell.h"

@implementation NoticeShopStroyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.stroyButton = [[FSCustomButton  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 108)];
        self.stroyButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [self.stroyButton setTitle:@"写下你的故事，让Ta更了解你" forState:UIControlStateNormal];
        [self.stroyButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.stroyButton.buttonImagePosition = FSCustomButtonImagePositionBottom;
        [self.stroyButton setImage:UIImageNamed(@"editAddshop_img") forState:UIControlStateNormal];
        [self.stroyButton setAllCorner:8];
        self.stroyButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.stroyButton];
        
        [self.stroyButton addTarget:self action:@selector(editInfoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    if (shopModel.myShopM.tale && shopModel.myShopM.tale.length) {
        self.backView.hidden = NO;
        self.stroyButton.hidden = YES;
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, ((shopModel.myShopM.taleHeight>88)?(shopModel.myShopM.taleHeight+20):108));
        self.contentL.frame = CGRectMake(10, 10, DR_SCREEN_WIDTH-60, ((shopModel.myShopM.taleHeight>88)?(shopModel.myShopM.taleHeight):88));
        self.contentL.attributedText = shopModel.myShopM.taleAtstr;
    }else{
        _backView.hidden = YES;
        self.stroyButton.hidden = NO;
    }
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 108)];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:_backView];
        
        self.contentL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-60, 88)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_backView addSubview:self.contentL];
    }
    return _backView;
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
