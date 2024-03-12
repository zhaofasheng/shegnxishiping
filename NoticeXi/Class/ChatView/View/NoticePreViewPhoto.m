//
//  NoticePreViewPhoto.m
//  NoticeXi
//
//  Created by li lei on 2022/5/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticePreViewPhoto.h"
#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "NoticeCropImageView.h"

@interface NoticePreViewPhoto()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

{
    
    UICollectionViewFlowLayout *_layout;
    NSInteger _currentIndex;

}

@end

@implementation NoticePreViewPhoto

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [TZImageManager manager].shouldFixOrientation = YES;
        [self configCollectionView];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setModels:(NSMutableArray *)models{
    _models = models;
    _currentIndex = 0;
    [_collectionView reloadData];
    [self refreshChoiceModel];
    self.navView.hidden = NO;
    self.tabView.hidden = NO;
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    
}

- (void)creatShowAnimation
{
    self.transform = CGAffineTransformMakeScale(0.70, 0.70);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (DR_SCREEN_WIDTH + 20), 0);
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZPhotoPreviewCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
    [_collectionView registerClass:[TZVideoPreviewCell class] forCellWithReuseIdentifier:@"TZVideoPreviewCell"];
    [_collectionView registerClass:[TZGifPreviewCell class] forCellWithReuseIdentifier:@"TZGifPreviewCell"];
    
    _layout.itemSize = CGSizeMake(DR_SCREEN_WIDTH + 20, DR_SCREEN_HEIGHT);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, DR_SCREEN_WIDTH + 20, DR_SCREEN_HEIGHT);
    [_collectionView setCollectionViewLayout:_layout];
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    self.navView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
    [self addSubview:self.navView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_whitebackbutton") forState:UIControlStateNormal];
    [self.navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backDissClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.choiceSelectView = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [self.choiceSelectView setBackgroundImage:UIImageNamed(@"Image_choicelistimg") forState:UIControlStateNormal];
    [self.navView addSubview:self.choiceSelectView];
    [self.choiceSelectView addTarget:self action:@selector(choiceImageClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    self.tabView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
    [self addSubview:self.tabView];
    
    self.cirButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 13, 24, 24)];
    [self.cirButton setBackgroundImage:UIImageNamed(@"Image_choicelcirimg") forState:UIControlStateNormal];
    [self.tabView addSubview:self.cirButton];
    [self.cirButton addTarget:self action:@selector(cirClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-86, 7, 66, 36)];
    self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [self.sendButton setAllCorner:4];
    self.sendButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tabView addSubview:self.sendButton];
    [self.sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setIsOnlyOne:(BOOL)isOnlyOne{
    _isOnlyOne = isOnlyOne;
    [self.sendButton setTitle:@"确定" forState:UIControlStateNormal];
    self.choiceSelectView.hidden = YES;
}

//进入裁剪模式
- (void)cirClick{
    if (!_models.count) {
        return;
    }
    TZAssetModel *model = _models[_currentIndex];
    if (model.type == TZAssetModelMediaTypePhotoGif){
        [[NoticeTools getTopViewController] showToastWithText:@"动图不允许裁剪哦~"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[TZImageManager manager] getOriginalPhotoDataWithAsset:model.asset progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        
    } completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
        NoticeCropImageView *cropImageView = [[NoticeCropImageView alloc] initCropViewWithImage:[UIImage imageWithData:data] andToView:self];
        cropImageView.getCropImageBlock = ^(UIImage * _Nonnull cropImage) {
            TZAssetModel *model = weakSelf.models[_currentIndex];
            model.cropImage = cropImage;
            [weakSelf.collectionView reloadData];
            [weakSelf refreshChoiceModel];
        };
    }];
}

//选中或者取消图片
- (void)choiceImageClick{
    TZAssetModel *model = _models[_currentIndex];
    model.isSelected = !model.isSelected;
    [self refreshChoiceModel];
}

- (void)refreshChoiceModel{
    TZAssetModel *model = _models[_currentIndex];
    [self.choiceSelectView setBackgroundImage:UIImageNamed(model.isSelected?@"Image_choiceadd_b": @"Image_choicelistimg") forState:UIControlStateNormal];
    
    [self.choiceArr removeAllObjects];
    for (TZAssetModel *choiceM in _models) {
        if(choiceM.isSelected){
            [_choiceArr addObject:choiceM];
        }
    }
    if (!self.isOnlyOne) {
        if(_choiceArr.count){
            [self.sendButton setTitle:[NSString stringWithFormat:@"发送(%ld)",_choiceArr.count] forState:UIControlStateNormal];
        }else{
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        }
    }

    
}

- (NSMutableArray *)choiceArr{
    if(!_choiceArr){
        _choiceArr = [[NSMutableArray alloc] init];
    }
    return _choiceArr;
}

- (void)sendClick{
    if (self.isOnlyOne) {
        [self.choiceArr removeAllObjects];
        if (_models.count && _currentIndex == 0) {
            TZAssetModel *model = _models[_currentIndex];
            [_choiceArr addObject:model];
            if(self.choiceArr.count){
                if(self.getPhotosBlock){
                    self.getPhotosBlock(self.choiceArr);
                }
            }
            [self backDissClick];
            return;
        }
  
    }
    if(self.choiceArr.count){
        if(self.getPhotosBlock){
            self.getPhotosBlock(self.choiceArr);
        }
    }
    [self backDissClick];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TZAssetModel *model = _models[indexPath.item];
    
    TZAssetPreviewCell *cell;
    __weak typeof(self) weakSelf = self;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZGifPreviewCell" forIndexPath:indexPath];
    
    cell.model = model;
    [cell setSingleTapGestureBlock:^{

        weakSelf.hideToolsView = !weakSelf.hideToolsView;
        weakSelf.navView.hidden = weakSelf.hideToolsView;
        weakSelf.tabView.hidden = weakSelf.hideToolsView;
    }];
    return cell;
}

- (void)backDissClick{
    [self removeFromSuperview];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _currentIndex = index;
    [self refreshChoiceModel];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    } else if ([cell isKindOfClass:[TZVideoPreviewCell class]]) {
        [(TZVideoPreviewCell *)cell pausePlayerAndShowNaviBar];
    }
    
}
@end
