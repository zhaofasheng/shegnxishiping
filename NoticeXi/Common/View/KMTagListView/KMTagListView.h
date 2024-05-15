//
//  KMTagListView.h
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMTagListView;
@protocol KMTagListViewDelegate<NSObject>
@optional
- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content;

@end

@interface KMTagListView : UIScrollView
@property (nonatomic, assign) BOOL oneClick;//单点
@property (nonatomic, weak)id<KMTagListViewDelegate> delegate_;
@property (nonatomic, assign) BOOL hasImge;//带图片的标签
@property (nonatomic, assign) BOOL isChoiceTap;
- (void)setupSubViewsWithTitles:(NSArray *)titles;
@property (nonatomic, strong) NSMutableArray *labelItems;
- (void)setupCustomeSubViewsWithTitles:(NSArray *)titles;//
- (void)setupCustomeSubViewsWithTitles:(NSArray *)titles defaultStr:(NSString *)defaultStr;
- (void)setupCustomeColorSubViewsWithTitles:(NSArray *)titles;
- (void)setupCustomeImgSubViewsWithTitles1:(NSMutableArray *)titles;//固定图片
- (void)setupCustomeImgSubViewsWithTitles:(NSMutableArray *)titles;//不固定图片
@end
