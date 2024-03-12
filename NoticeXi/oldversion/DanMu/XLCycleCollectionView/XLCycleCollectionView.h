//
//  XLCycleCollectionView.h
//  XLCycleCollectionViewDemo
//
//  Created by 赵发生 on 2017/3/6.
//  Copyright © 2017年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDanMuModel.h"
@interface XLCycleCollectionView : UIView

@property (nonatomic, strong) NSArray<NSString *> *data;
@property (nonatomic, strong) NSMutableArray *bokeArr;
@property (nonatomic, copy) void(^clickBokeBlock)(NoticeDanMuModel *bokeM);
/**
 自动翻页 默认 NO
 */
@property (nonatomic, assign) BOOL autoPage;

@end
