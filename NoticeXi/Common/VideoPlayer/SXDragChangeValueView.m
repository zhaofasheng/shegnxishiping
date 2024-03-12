//
//  SXDragChangeValueView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXDragChangeValueView.h"

@implementation SXDragChangeValueView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 24, 24)];
        imageV.image = UIImageNamed(@"sxchangevalue_img");
        [self addSubview:imageV];
        self.markImageView = imageV;
        
        [self addSubview:self.progress];
        [self setAllCorner:4];
    }
    return self;
}

- (void)setIsBright:(BOOL)isBright{
    _isBright = isBright;
    if (isBright) {
        self.markImageView.image = UIImageNamed(@"sxchangebright_img");
    }else{
        self.markImageView.image = UIImageNamed(@"sxchangevalue_img");
    }
}

- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(37, 14, self.frame.size.width-47, 4)];
        _progress.progressTintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        _progress.trackTintColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.6];
        
    }
    return _progress;
}

@end
