//
//  SXplayPayVideoDetailSection.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXplayPayVideoDetailSection.h"

@implementation SXplayPayVideoDetailSection


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
      
        self.backgroundColor = [UIColor whiteColor];

        
        UILabel *redPayL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,100,40)];
        redPayL.font = XGFifthBoldFontSize;
        redPayL.text = @"目录";
        redPayL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:redPayL];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(115,0,DR_SCREEN_WIDTH-115-15, 40)];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:_numL];
        _numL.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setModel:(SXPayForVideoModel *)model{
    _model = model;
    self.numL.text = [NSString stringWithFormat:@"已更新%@课时  |  共%@课时",model.published_episodes,model.episodes];
}
@end
