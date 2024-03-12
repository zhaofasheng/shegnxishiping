//
//  SXNoDataDefaultShopInfoView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXNoDataDefaultShopInfoView.h"

@implementation SXNoDataDefaultShopInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(frame.size.width-16, (frame.size.height-16)/2, 16, 16)];
        markImageV.image = UIImageNamed(@"sxeditshopinfo_img");
        [self addSubview:markImageV];
        self.markImageView = markImageV;
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-16, frame.size.height)];
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.font = THRETEENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.markL];
    }
    return self;
}
@end
