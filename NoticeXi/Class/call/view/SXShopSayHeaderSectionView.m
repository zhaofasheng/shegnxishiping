//
//  SXShopSayHeaderSectionView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayHeaderSectionView.h"

@implementation SXShopSayHeaderSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 200,46)];
        label.font = XGFourthBoldFontSize;
        label.textColor =[UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:label];
        _mainTitleLabel = label;
        
        
    }
    return self;
}



@end
