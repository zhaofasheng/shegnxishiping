//
//  XLCycleCollectionView.m
//  XLCycleCollectionViewDemo
//
//  Created by 赵发生 on 2017/3/6.
//  Copyright © 2017年 赵发生. All rights reserved.
//

#import "XLCycleCollectionView.h"
#import "XLCycleCell.h"

//轮播间隔
static CGFloat ScrollInterval = 3.0f;

@interface XLCycleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;
   
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation XLCycleCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = true;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[XLCycleCell class] forCellWithReuseIdentifier:@"XLCycleCell"];
    self.collectionView.showsHorizontalScrollIndicator = false;
    [self addSubview:self.collectionView];
    
    CGFloat controlHeight = 35.0f;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width/2,0, self.bounds.size.width/2, controlHeight)];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    if (@available(iOS 16.0, *)) {
        self.pageControl.direction = UIPageControlDirectionLeftToRight;
    } else {
        // Fallback on earlier versions
    }
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [self addSubview:self.pageControl];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ScrollInterval target:self selector:@selector(showNext) userInfo:nil repeats:true];
    self.timer.fireDate = [NSDate distantFuture];
    _autoPage = NO;
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(self.clickBokeBlock && self.bokeArr.count){
        if(self.bokeArr.count > (indexPath.row-1)){
            self.clickBokeBlock(self.bokeArr[indexPath.row-1]);
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"XLCycleCell";
    XLCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (self.justImag) {
        [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:self.titles[indexPath.row]]];
    }else{
        cell.model = self.titles[indexPath.row];
    }
    
    return cell;
}

//手动拖拽结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self cycleScroll];
    //拖拽动作后间隔3s继续轮播
    if (_autoPage) {
        self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:ScrollInterval];
    }
}

//自动轮播结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self cycleScroll];
}

//循环显示
- (void)cycleScroll {
    NSInteger page = self.collectionView.contentOffset.x/self.collectionView.bounds.size.width;
    if (page == 0) {//滚动到左边
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * (self.titles.count - 2), 0);
        self.pageControl.currentPage = self.titles.count - 2;
    }else if (page == self.titles.count - 1){//滚动到右边
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width, 0);
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = page - 1;
    }
}


#pragma mark -
#pragma mark Setter
//设置数据时在第一个之前和最后一个之后分别插入数据
- (void)setData:(NSArray<NSString *> *)data {
    if (!data.count) {
        return;
    }
    self.titles = [NSMutableArray arrayWithArray:data];
    [self.titles addObject:data.firstObject];
    [self.titles insertObject:data.lastObject atIndex:0];
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
    self.pageControl.numberOfPages = data.count;
}

- (void)setBokeArr:(NSMutableArray *)bokeArr{
    
    _bokeArr = bokeArr;
    if(!bokeArr.count){
        return;
    }
    if (!self.justImag) {
        self.titles = [NSMutableArray arrayWithArray:bokeArr];
        [self.titles addObject:bokeArr.firstObject];
        [self.titles insertObject:bokeArr.lastObject atIndex:0];
    }
 
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
    self.pageControl.numberOfPages = bokeArr.count;

    [self.collectionView reloadData];
}

- (void)setAutoPage:(BOOL)autoPage {
    _autoPage = autoPage;
    NSDate *fireDate = autoPage ? [NSDate dateWithTimeIntervalSinceNow:ScrollInterval] : [NSDate distantFuture];
    self.timer.fireDate = fireDate;
}

#pragma mark -
#pragma mark 轮播方法
//自动显示下一个
- (void)showNext {
    //手指拖拽是禁止自动轮播
    if (self.collectionView.isDragging) {return;}
    CGFloat targetX =  self.collectionView.contentOffset.x + self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(targetX, 0) animated:true];
}


- (void)dealloc {
    [self.timer invalidate];
}

@end
