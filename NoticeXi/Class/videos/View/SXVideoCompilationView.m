//
//  SXVideoCompilationView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCompilationView.h"
#import "SXVideoCompilationListView.h"

@interface SXVideoCompilationView()


@end

@implementation SXVideoCompilationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.2];
        
        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 6, 20, 20)];
        imageV.image = UIImageNamed(@"sxvideocompil_img1");
        imageV.userInteractionEnabled = YES;
        [self addSubview:imageV];
        
        UIImageView *imageV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-16, 9, 16, 16)];
        imageV1.image = UIImageNamed(@"sxvideocompil_img2");
        imageV1.userInteractionEnabled = YES;
        [self addSubview:imageV1];
        
        self.nameL = [[UILabel  alloc] initWithFrame:CGRectMake(43, 0, DR_SCREEN_WIDTH-43-16-15, 32)];
        self.nameL.font = THRETEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor whiteColor];
        [self addSubview:self.nameL];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listTap)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    self.nameL.text = videoModel.compilation_name;
}

- (void)listTap{
    SXVideoCompilationListView *listView = [[SXVideoCompilationListView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.currentVideoId = self.videoModel.vid;
    listView.videoModel = self.videoModel;
    __weak typeof(self) weakSelf = self;
    listView.choiceHeJiVideoBlock = ^(SXVideosModel * _Nonnull currentModel, NSMutableArray * _Nonnull heVideoArr) {
        if (weakSelf.choiceHeJiVideoBlock) {
            weakSelf.choiceHeJiVideoBlock(currentModel, heVideoArr);
        }
    };
    [listView show];
}

@end
