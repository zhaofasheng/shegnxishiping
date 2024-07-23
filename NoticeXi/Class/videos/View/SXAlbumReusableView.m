//
//  SXAlbumReusableView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAlbumReusableView.h"

@implementation SXAlbumReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.albumL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-25, 28)];
        self.albumL.font = XGTwentyBoldFontSize;
        self.albumL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.albumL.text = @"专辑名称";
        [self addSubview:self.albumL];
        
        self.numL = [[UILabel  alloc] initWithFrame:CGRectMake(15,52, DR_SCREEN_WIDTH-30-85, 22)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.numL.text = @"12个视频";
        [self addSubview:self.numL];
    }
    return self;
}

@end
