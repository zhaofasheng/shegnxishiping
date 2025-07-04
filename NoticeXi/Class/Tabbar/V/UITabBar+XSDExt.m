//
//  UITabBar+XSDExt.m
//  NoticeXi
//
//  Created by li lei on 2018/11/13.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "UITabBar+XSDExt.h"

#define TabbarItemNums  5.0    //tabbar的数量 如果是5个设置为5

@implementation UITabBar (XSDExt)

//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 3.0;//圆形
    badgeView.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX =  (index + 0.6) / TabbarItemNums;
   
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    if (index == 1) {
        x += GET_STRWIDTH(@"课程", 16, 20)+4;
    }
    CGFloat y = ceilf(0.1 * tabFrame.size.height)+5;
    badgeView.frame = CGRectMake(x, y, 6.0, 6.0);//圆形大小为6
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
