//
//  NoticePhotoWallCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoWallCell.h"

@implementation NoticePhotoWallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        _postImageView.layer.cornerRadius = 4;
        _postImageView.layer.masksToBounds = YES;
        _postImageView.contentMode = UIViewContentModeScaleAspectFill;
        _postImageView.clipsToBounds = YES;
        _postImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_postImageView];
        
        self.lineView = [[UIView  alloc] initWithFrame:_postImageView.bounds];
        [self.contentView addSubview:self.lineView];
        self.lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.lineView.layer.cornerRadius = 4;
        self.lineView.layer.masksToBounds = YES;
        self.lineView.layer.borderWidth = 2;
        self.lineView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.lineView.hidden = YES;
    }
    return self;
}

- (void)setHeight:(CGFloat)height{
    _height = height;
    self.postImageView.frame = CGRectMake(0, 0, height, height);
    self.lineView.frame = self.postImageView.bounds;
}

- (void)setPhotoModel:(NoticeShopDataIdModel *)photoModel{
    _photoModel = photoModel;
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.photo_url]];
    if (self.canChoice) {
        self.lineView.hidden = photoModel.isChoice?NO:YES;
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
