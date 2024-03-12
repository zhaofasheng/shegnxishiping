//
//  XLCardSwitchFlowLayout.m
//  XLCardSwitchDemo
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XLCardSwitchFlowLayout.h"


@implementation XLCardSwitchFlowLayout

//初始化方法
- (void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.itemSize = CGSizeMake([self itemWidth], [self itemHeight]);
    self.minimumLineSpacing = 15;
    
}

#pragma mark -
#pragma mark 配置方法
//卡片宽度
- (CGFloat)itemWidth {
    return self.width;
}

- (CGFloat)itemHeight {
    return self.collectionView.frame.size.height;
}

//是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

@end
