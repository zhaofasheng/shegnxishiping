//
//  NoticeDanMuHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuHeaderView.h"
@implementation NoticeDanMuHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,frame.size.height)];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, 0);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        __weak typeof(self) weakSelf = self;
        self.playeBoKeView = [[NoticePlayerBokeView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, scrollView.frame.size.height)];
        [scrollView addSubview:self.playeBoKeView];
        self.playeBoKeView.choiceDanMuBlock = ^(BOOL goDanMu) {
            [weakSelf hotBtnClick];
        };
        self.playeBoKeView.clickListBlock = ^(BOOL list) {
            if (weakSelf.clickListBlock) {
                weakSelf.clickListBlock(YES);
            }
        };

    }
    return self;
}

- (void)setBokeModel:(NoticeDanMuModel *)bokeModel{
    _bokeModel = bokeModel;
     
    self.playeBoKeView.bokeModel = bokeModel;
    
}

- (void)selfBtnClick{
    self.isInduce = YES;
    [self.selfBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    self.line.frame = CGRectMake(20+(self.selfBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44), 2);
    self.scrollView.contentOffset = CGPointMake(0,0);
    if (self.hideKeyBordBlock) {
        self.hideKeyBordBlock(YES);
    }
    if (self.hideinputBlock) {
        self.hideinputBlock(YES);
    }
}

- (void)hotBtnClick{
    self.isInduce = NO;
    if (self.hideinputBlock) {
        self.hideinputBlock(NO);
    }
    [self.hotBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.selfBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    self.line.frame = CGRectMake(self.hotBtn.frame.origin.x+(self.hotBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44), 2);
    self.scrollView.contentOffset = CGPointMake(DR_SCREEN_WIDTH,0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;
    
    if (page == 0) {
        [self.selfBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.hotBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.line.frame = CGRectMake(20+(self.selfBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44), 2);
        if (self.hideKeyBordBlock) {
            self.hideKeyBordBlock(YES);
        }
        if (self.hideinputBlock) {
            self.hideinputBlock(YES);
        }
    }else{
        
        self.isInduce = NO;
        [self.hotBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.selfBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.line.frame = CGRectMake(self.hotBtn.frame.origin.x+(self.hotBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44), 2);
        if (self.hideinputBlock) {
            self.hideinputBlock(NO);
        }
    }
}
@end
