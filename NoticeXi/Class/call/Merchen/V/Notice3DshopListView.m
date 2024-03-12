//
//  Notice3DshopListView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "Notice3DshopListView.h"
#import "NoticeMyShopModel.h"
#import "NoticeShop3DListCell.h"
#import "NoticdShopDetailForUserController.h"
@implementation Notice3DshopListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 调用展示
        self.sphereView = [[YoungSphere alloc] initWithFrame:self.bounds];

        _sphereView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        [self addSubview:_sphereView];
        
        CGFloat width = GET_STRWIDTH(@"的的的的4", 11, 16);
        
        self.cellArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 20; i ++) {
            NoticeShop3DListCell *cell = [[NoticeShop3DListCell  alloc] initWithFrame:CGRectMake(0, 0, width, width+18)];
            cell.hidden = YES;
            cell.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)];
            [cell addGestureRecognizer:tap];
            [_sphereView addSubview:cell];
            [self.cellArr addObject:cell];

        }
     
    }
    return self;
}

- (void)setShopArr:(NSMutableArray *)shopArr{
    _shopArr = shopArr;

    for (NoticeShop3DListCell *cell in self.cellArr) {
        cell.shopNameL.text = @"";
        cell.hidden = YES;
    }
    if (!_shopArr.count) {
        return;
    }
    for (int i = 0; i < ((shopArr.count < 20) ? shopArr.count : 20); i++) {
      
        NoticeShop3DListCell *cell = self.cellArr[i];
        if (i < shopArr.count) {
            cell.hidden = NO;
            NoticeMyShopModel *model = shopArr[i];
            cell.shopNameL.text = model.shop_name;
        }
    }
    [_sphereView setCloudTags:self.cellArr];
}

-(CABasicAnimation *)opacityForever_Animation1:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.3f];
    animation.toValue = [NSNumber numberWithFloat:0.1f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    return animation;
}

-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.8f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    return animation;
}


// 点击后的效果图
- (void)buttonPressed:(UITapGestureRecognizer *)tap
{
    NoticeShop3DListCell *cell = (NoticeShop3DListCell *)tap.view;
    

    if (cell.tag <_shopArr.count) {
        cell.hidden = YES;
        NoticeMyShopModel *model = _shopArr[cell.tag];
        NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
        ctl.shopModel = model;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)startRadi{
    [_sphereView timerStart];
}
- (void)stopRadi{
    [_sphereView timerStop];
}
@end
