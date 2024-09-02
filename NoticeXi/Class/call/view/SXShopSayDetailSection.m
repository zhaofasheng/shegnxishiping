//
//  SXShopSayDetailSection.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayDetailSection.h"

@implementation SXShopSayDetailSection
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,10, 200,20)];
        label.font = XGFourthBoldFontSize;
        label.textColor =[UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:label];
        _mainTitleLabel = label;

    }
    return self;
}


@end
