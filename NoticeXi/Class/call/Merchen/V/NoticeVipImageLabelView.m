//
//  NoticeVipImageLabelView.m
//  NoticeXi
//
//  Created by li lei on 2023/8/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipImageLabelView.h"

@implementation NoticeVipImageLabelView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-23, frame.size.width, 17)];
        self.label.font = TWOTEXTFONTSIZE;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

@end
