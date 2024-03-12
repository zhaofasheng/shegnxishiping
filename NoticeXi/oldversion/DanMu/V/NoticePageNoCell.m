//
//  NoticePageNoCell.m
//  NoticeXi
//
//  Created by li lei on 2023/10/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticePageNoCell.h"

@implementation NoticePageNoCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        self.backgroundColor = [UIColor whiteColor];
        self.contentView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.numberL.font = FIFTHTEENTEXTFONTSIZE;
        self.numberL.textAlignment = NSTextAlignmentCenter;
        self.numberL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.numberL];
        self.numberL.backgroundColor = [UIColor colorWithHexString:@"#00ABE4"];
        [self.numberL setAllCorner:4];
    
    }
    return self;
}
@end
