//
//  SXShopSayDayCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayDayCell.h"

@implementation SXShopSayDayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backcontentView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 84)];
        self.backcontentView.layer.cornerRadius = 8;
        self.backcontentView.layer.masksToBounds = YES;
        [self addSubview:self.backcontentView];
        self.backcontentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    }
    return self;
}

- (void)setModel:(SXShopSayListModel *)model{
    _model = model;
    
    _contentL.hidden = YES;
    _sayImageView1.hidden = YES;
    
    if (model.hasImageV) {//有图片
        self.sayImageView1.hidden = NO;
        self.backcontentView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 84);
    }else{
        self.backcontentView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 40);
    }
    
    if (model.contentHeight && model.content) {
        self.contentL.hidden = NO;
        if (model.hasImageV) {//有图片
            self.contentL.frame = CGRectMake(82, 12, self.backcontentView.frame.size.width-82-10, 60);
        }else{
            self.contentL.frame = CGRectMake(10, 10, self.backcontentView.frame.size.width-20, 20);
        }
        self.contentL.text = model.content;
    }
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 66, DR_SCREEN_WIDTH-50, 0)];
        _contentL.numberOfLines = 0;
        _contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _contentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.backcontentView addSubview:_contentL];
    }
    return _contentL;
}

- (UIImageView *)sayImageView1{
    if (!_sayImageView1) {
        _sayImageView1 = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
        _sayImageView1.layer.cornerRadius = 4;
        _sayImageView1.layer.masksToBounds = YES;
        _sayImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _sayImageView1.clipsToBounds = YES;
        [self.backcontentView addSubview:_sayImageView1];
        _sayImageView1.userInteractionEnabled = YES;
    }
    return _sayImageView1;
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
