//
//  SXHasGetSearisListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasGetSearisListCell.h"

@implementation SXHasGetSearisListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 126)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setAllCorner:8];
        [self addSubview:self.backView];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 80, 106)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.backView addSubview:self.coverImageView];
        
        _titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(100,12,self.backView.frame.size.width-10-100, 22)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_titleL];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(100,38,self.backView.frame.size.width-10-100, 17)];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_numL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(100,64,self.backView.frame.size.width-10-100, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.backView addSubview:_markL];
        
        _beforeL = [[UILabel alloc] initWithFrame:CGRectMake(100,99,self.backView.frame.size.width-10-100, 17)];
        _beforeL.font = TWOTEXTFONTSIZE;
        _beforeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:_beforeL];
    }
    return self;
}

- (void)setModel:(SXPayForVideoModel *)model{
    _model = model;
    self.numL.text = [NSString stringWithFormat:@"共%@课时  |  已更新%@课时",model.episodes,model.published_episodes];
    self.titleL.text = model.series_name;
    if (model.fromUser) {
        self.titleL.text = [NSString stringWithFormat:@"(%@赠送)%@",model.fromUser.nick_name,model.series_name];
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.simple_cover_url]];
    if (model.updateM && model.updateM.title) {
        self.markL.text = [NSString stringWithFormat:@"更新：%@",model.updateM.title];
    }else{
        self.markL.text = @"";
    }
    
    NSString *str = [SXTools getPayPlayLastsearisId:model.seriesId];
    if (str) {
        _beforeL.text = [NSString stringWithFormat:@"上次看到：%@",str];
    }else{
        _beforeL.text = @"";
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
