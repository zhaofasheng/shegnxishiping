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
        backView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeName)];
        [backView addGestureRecognizer:tap];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(12, 0,200,56)];
        self.nameL.font = SIXTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.nameL];
        
 
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backView.frame)+20, 100, 20)];
        label.text = @"性别";
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        label.font = XGFifthBoldFontSize;
        [self.contentView addSubview:label];
        
        CGFloat width = (DR_SCREEN_WIDTH-55)/2;
        CGFloat strWidth = GET_STRWIDTH(@"男", 16, 20);
        CGFloat space = (width-strWidth-2-24)/2;
        
        //self.sexImageView.image = UIImageNamed(@"sx_shop_male");//sx_shop_fale女
        UIView *maleBtn = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+8, width, 48)];
        maleBtn.userInteractionEnabled = YES;
        self.maleButton = maleBtn;
        self.maleButton.layer.cornerRadius = 10;
        self.maleButton.layer.borderWidth = 2;
        self.maleButton.layer.borderColor = [UIColor colorWithHexString:@"#72B4FF"].CGColor;
        
        self.boyImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(space, 12, 24, 24)];
        self.boyImageV.image = UIImageNamed(@"sx_shop_male");
        self.boyImageV.userInteractionEnabled = YES;
        
        self.boyL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.boyImageV.frame)+2, 0, strWidth, 48)];
        self.boyL.text = @"男";
        self.boyL.font = SIXTEENTEXTFONTSIZE;
        self.boyL.textColor = [UIColor colorWithHexString:@"#72B4FF"];
        [self.maleButton addSubview:self.boyL];
        
        [self.maleButton addSubview:self.boyImageV];
        
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boyTap)];
        [self.maleButton addGestureRecognizer:tap1];
        
        [self.contentView addSubview:maleBtn];
        
        UIView *faleBtn = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.maleButton.frame)+15, CGRectGetMaxY(label.frame)+8, width, 48)];
        faleBtn.userInteractionEnabled = YES;
        self.faleButton = faleBtn;
        self.faleButton.layer.cornerRadius = 10;
        self.faleButton.layer.borderWidth = 2;
        self.faleButton.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
        
        self.girlImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(space, 12, 24, 24)];
        self.girlImageV.image = UIImageNamed(@"sx_shop_falegray");
        self.girlImageV.userInteractionEnabled = YES;
        
        self.girlL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.girlImageV.frame)+2, 0, strWidth, 48)];
        self.girlL.text = @"女";
        self.girlL.font = SIXTEENTEXTFONTSIZE;
        self.girlL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.faleButton addSubview:self.girlL];
        self.faleButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.faleButton addSubview:self.girlImageV];
        
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(girlTap)];
        [self.faleButton addGestureRecognizer:tap2];
        
        [self.contentView addSubview:faleBtn];
    }
    return self;
}

- (void)boyTap{
    self.boyL.textColor = [UIColor colorWithHexString:@"#72B4FF"];
    self.maleButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.boyImageV.image = UIImageNamed(@"sx_shop_male");
    self.maleButton.layer.borderColor = [UIColor colorWithHexString:@"#72B4FF"].CGColor;
    
    self.girlL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.girlImageV.image = UIImageNamed(@"sx_shop_falegray");
    self.faleButton.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
    self.faleButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    if (self.sexBlock) {
        self.sexBlock(YES);
    }
}

- (void)girlTap{
    self.boyL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.maleButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.boyImageV.image = UIImageNamed(@"sx_shop_malegray");
    self.maleButton.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
    
    self.faleButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.girlL.textColor = [UIColor colorWithHexString:@"#FF7D9E"];
    self.girlImageV.image = UIImageNamed(@"sx_shop_fale");
    self.faleButton.layer.borderColor = [UIColor colorWithHexString:@"#FF7D9E"].CGColor;
    if (self.sexBlock) {
        self.sexBlock(NO);
    }
}

- (void)changeName{
    if (self.changeNameBlock) {
        self.changeNameBlock(YES);
    }
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
