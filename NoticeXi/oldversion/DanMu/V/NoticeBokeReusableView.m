//
//  NoticeBokeReusableView.m
//  NoticeXi
//
//  Created by li lei on 2023/11/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBokeReusableView.h"

@implementation NoticeBokeReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        XLCycleCollectionView *cyleView = [[XLCycleCollectionView alloc] initWithFrame:CGRectMake(5, 0,frame.size.width-10, frame.size.height-5)];
      
        cyleView.autoPage = YES;
        [self addSubview:cyleView];
        self.cyleView = cyleView;
    }
    return self;
}


@end
