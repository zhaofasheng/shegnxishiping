//
//  SXShopsliuyanCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopsliuyanCell.h"

@implementation SXShopsliuyanCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        
        self.userInteractionEnabled = YES;
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16,16,36, 36)];
        _iconImageView.layer.cornerRadius = 18;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
//        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-14, CGRectGetMaxY(_iconImageView.frame)-14,14, 14)];
        self.markImage.image = UIImageNamed(@"sxrenztub_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15,180, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-140,14,140, 16)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:_timeL];
        
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,38,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-10-50, 16)];
        _infoL.font = ELEVENTEXTFONTSIZE;
        _infoL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:_infoL];
        
        _numL = [[UILabel alloc] init];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.backgroundColor = [[UIColor colorWithHexString:@"#EE4B4E"] colorWithAlphaComponent:1];
        _numL.layer.cornerRadius = 7;
        _numL.layer.masksToBounds = YES;
        _numL.textAlignment = NSTextAlignmentCenter;
        _numL.textColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:_numL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 67, DR_SCREEN_WIDTH-10-CGRectGetMaxX(_iconImageView.frame), 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:line];

    }
    return self;
}

- (void)setLyModel:(NoticeOrderListModel *)lyModel{
    _lyModel = lyModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:lyModel.shop_avatar_url]];
    self.nickNameL.text = lyModel.shop_name;
    
    self.infoL.text = lyModel.liuyModel.resource_type.intValue == 1 ? lyModel.liuyModel.resource_uri : (lyModel.liuyModel.resource_type.intValue==3?@"[语音]":@"[图片]");
    self.timeL.text = lyModel.liuyModel.created_at;
    
    _numL.frame = CGRectMake(DR_SCREEN_WIDTH-((GET_STRWIDTH(lyModel.unread_comment_num, 9, 14)+5)>14?(GET_STRWIDTH(lyModel.unread_comment_num, 9, 14)+5):14)-15, 39, ((GET_STRWIDTH(lyModel.unread_comment_num, 9, 14)+5)>14?(GET_STRWIDTH(lyModel.unread_comment_num, 9, 14)+5):14), 14);
    _numL.hidden = !lyModel.unread_comment_num.intValue;
    _numL.text = lyModel.unread_comment_num;
    
    self.markImage.hidden = lyModel.is_certified.boolValue?NO:YES;
}

- (void)userInfoTap{
    
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
