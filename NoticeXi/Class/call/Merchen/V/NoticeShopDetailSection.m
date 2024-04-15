//
//  NoticeShopDetailSection.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopDetailSection.h"

@implementation NoticeShopDetailSection

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 200,37)];
        label.font = XGFifthBoldFontSize;
        label.textColor =[UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:label];
        _mainTitleLabel = label;
        
        
    }
    return self;
}

- (void)moreComTap{
    if (self.tapBlock) {
        self.tapBlock(YES);
    }
}

- (UIView *)subEditView{
    if (!_subEditView) {
        _subEditView = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100, 0, 100, 37)];
        _subEditView.userInteractionEnabled = YES;
        
        UIImageView *editImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(100-15-16, 21/2, 16, 16)];
        editImageV.image = UIImageNamed(@"sxshopcomlook_img");
        [_subEditView addSubview:editImageV];
        editImageV.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100-15-16-2, 37)];
        label.text = @"编辑";
        label.font = THRETEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        label.textAlignment = NSTextAlignmentRight;
        [_subEditView addSubview:label];
        [self.contentView addSubview:_subEditView];
        _editTitleLabel = label;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editclick)];
        [_subEditView addGestureRecognizer:tap];
    }
    return _subEditView;
}

- (void)editclick{
    if (self.editShopBlock) {
        self.editShopBlock(YES);
    }
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-215, 0, 200, 37)];
        _subTitleLabel.text = @"还没有评价";
        _subTitleLabel.font = THRETEENTEXTFONTSIZE;
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subTitleLabel];
        
        _subTitleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreComTap)];
        [_subTitleLabel addGestureRecognizer:tap];
    }
    return _subTitleLabel;
}

- (UIImageView *)subImageView{
    if (!_subImageView) {
        _subImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-16, 21/2, 16, 16)];
        _subImageView.image = UIImageNamed(@"sxshopcomlook_img");
        [self.contentView addSubview:_subImageView];
        _subImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreComTap)];
        [_subImageView addGestureRecognizer:tap];
    }
    return _subImageView;
}
@end
