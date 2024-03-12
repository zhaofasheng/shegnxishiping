//
//  NoticeVipIdentifyCell.m
//  NoticeXi
//
//  Created by li lei on 2023/8/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipIdentifyCell.h"

@implementation NoticeVipIdentifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 88, 107)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [backView setAllCorner:8];
        [self.contentView addSubview:backView];
        
        self.lelveL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.lelveL.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        self.lelveL.font = [UIFont fontWithName:@"zihunxinquhei" size:12];
        self.lelveL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.lelveL.textAlignment = NSTextAlignmentCenter;
        [self.lelveL setTopleftAndbottomRightCorner:8];
        [backView addSubview:self.lelveL];
        
        self.leveBackMarkImageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 56, 56)];
        [self.leveBackMarkImageV setAllCorner:28];
        [backView addSubview:self.leveBackMarkImageV];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 52, 52)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [whiteView setAllCorner:52/2];
        [self.leveBackMarkImageV addSubview:whiteView];
        
        self.levleMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 56, 52, 16)];
        [backView addSubview:self.levleMarkView];
        
        self.pointsL = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 88, 17)];
        self.pointsL.font = TWOTEXTFONTSIZE;
        self.pointsL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.pointsL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.pointsL];
        self.pointsL.text = @"0发电值";
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    
    switch (index) {
        case 0:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon0");
            self.levleMarkView.image = UIImageNamed(@"Image_leave0");
            self.lelveL.text = @"Lv0";
            self.pointsL.text = [NSString stringWithFormat:@"0%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 1:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon123");
            self.levleMarkView.image = UIImageNamed(@"Image_leave3");
            self.lelveL.text = @"Lv1";
            self.pointsL.text = [NSString stringWithFormat:@"10%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 2:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon456");
            self.levleMarkView.image = UIImageNamed(@"Image_leave6");
            self.lelveL.text = @"Lv4";
            self.pointsL.text = [NSString stringWithFormat:@"40%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 3:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon789");
            self.levleMarkView.image = UIImageNamed(@"Image_leave9");
            self.lelveL.text = @"Lv7";
            self.pointsL.text = [NSString stringWithFormat:@"70%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 4:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon101112");
            self.levleMarkView.image = UIImageNamed(@"Image_leave12");
            self.lelveL.text = @"Lv10";
            self.pointsL.text = [NSString stringWithFormat:@"100%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 5:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon131415");
            self.levleMarkView.image = UIImageNamed(@"Image_leave15");
            self.lelveL.text = @"Lv13";
            self.pointsL.text = [NSString stringWithFormat:@"130%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 6:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon161718");
            self.levleMarkView.image = UIImageNamed(@"Image_leave18");
            self.lelveL.text = @"Lv16";
            self.pointsL.text = [NSString stringWithFormat:@"160%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 7:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_icon192021");
            self.levleMarkView.image = UIImageNamed(@"Image_leave21");
            self.lelveL.text = @"Lv19";
            self.pointsL.text = [NSString stringWithFormat:@"190%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
        case 8:
            self.leveBackMarkImageV.image = UIImageNamed(@"Image_iconover21");
            self.levleMarkView.image = UIImageNamed(@"Image_leave22");
            self.lelveL.text = @"Lv22";
            self.pointsL.text = [NSString stringWithFormat:@"220%@",[NoticeTools getLocalStrWith:@"zb.fdz"]];
            break;
            
        default:
            break;
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
