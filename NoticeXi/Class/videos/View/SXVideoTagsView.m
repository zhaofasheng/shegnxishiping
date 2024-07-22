//
//  SXVideoTagsView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoTagsView.h"

@implementation SXVideoTagsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.keyView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 419)];
        self.keyView.backgroundColor = [UIColor whiteColor];
        [self.keyView setCornerOnTop:20];
        [self addSubview:self.keyView];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        [closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.keyView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.scrollView = [[UIScrollView  alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, self.keyView.frame.size.height-50-BOTTOM_HEIGHT)];
        [self.keyView addSubview:self.scrollView];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,0,DR_SCREEN_WIDTH, 0)];
        self.labeView = tagV;
        self.labeView.oneClick = YES;
        self.labeView.delegate_ = self;
        [self.scrollView addSubview:tagV];
        
   
    }
    return self;
}

- (void)setTitleArr:(NSMutableArray *)titleArr{
    _titleArr = titleArr;
    self.labeView.currentIndex = self.currentIndex;
    self.labeView.ySpace = 10;
    [self.labeView setupVideoSubViewsWithTitles:self.titleArr];
    CGRect rect = self.labeView.frame;
    rect.size.height = self.labeView.contentSize.height+5;
    self.labeView.frame = rect;
    self.scrollView.contentSize = CGSizeMake(0, self.labeView.frame.size.height);
}

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    if (index < self.titleArr.count) {
        if (self.choiceTagBlock) {
            self.choiceTagBlock((int)index);
        }
        [self closeView];
    }
}

- (void)closeView{
    [UIView animateWithDuration:0.2 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showTagsView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+20, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];

}

@end
