//
//  NoticeShopPhotosCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopPhotosCell.h"

@implementation NoticeShopPhotosCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.addPhotosButton = [[UIButton  alloc] initWithFrame:CGRectMake(20, 0, 64, 64)];
        [self.addPhotosButton setImage:UIImageNamed(@"editAddshop_img") forState:UIControlStateNormal];
        [self.addPhotosButton setAllCorner:8];
        self.addPhotosButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.addPhotosButton];
        
        [self.addPhotosButton addTarget:self action:@selector(editInfoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    DRLog(@"照片墙");
    if (shopModel.myShopM.photowallArr.count) {
        self.addPhotosButton.hidden = YES;
        self.photosWall.hidden = NO;
        self.photosWall.photos = shopModel.myShopM.photowallArr;
    }else{
        self.addPhotosButton.hidden = NO;
        _photosWall.hidden = YES;
    }
}

- (NoticeShopPhotosWall *)photosWall{
    if (!_photosWall) {
        _photosWall = [[NoticeShopPhotosWall  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-20, 64)];
        [self.contentView addSubview:_photosWall];
    }
    return _photosWall;
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
