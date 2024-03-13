//
//  NoticeChoiceDefaultVoiceImageView.m
//  NoticeXi
//
//  Created by li lei on 2023/11/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceDefaultVoiceImageView.h"

@interface NoticeChoiceDefaultVoiceImageView ()<TZImagePickerControllerDelegate>

@end

@implementation NoticeChoiceDefaultVoiceImageView

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,50,self.frame.size.width,self.contentView.frame.size.height-50-BOTTOM_HEIGHT-54-10);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        // 注册cell
        [_collectionView registerClass:[NoticeVoiceDefaultChoiceCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.contentView];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView setCornerOnTop:20];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools chinese:@"搞个适合此刻心情的封面吧" english:@"Pick cover" japan:@"カバーを選択してください"];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
 
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        self.closeBtn = closeBtn;
        [self.closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 添加点击手势
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
               
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20,self.contentView.frame.size.height-BOTTOM_HEIGHT-54, DR_SCREEN_WIDTH-40, 44)];
        button.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [button setAllCorner:22];
        [button setTitle:[NoticeTools getLocalStrWith:@"xl.suresure"] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)refreshCurrent{
    if(self.hasLocaChoice){
        self.hasLocaChoice = NO;
        BOOL hasChoiceDefault = NO;
        for (NoticeVoiceDefaultImgModel *imgM in self.dataArr) {
            imgM.currentChoice = NO;
        }
        
        for (NoticeVoiceDefaultImgModel *imgModel in self.dataArr) {
            if(imgModel.cover_type.intValue == 2){//存在用户自己选中的
                hasChoiceDefault = YES;
                imgModel.currentChoice = YES;
                break;
            }
        }
        
        if(!hasChoiceDefault){//没有自己选择的则取默认的
            for (NoticeVoiceDefaultImgModel *imgModel in self.dataArr) {
                if(imgModel.cover_type.intValue == 1){//默认的
                    hasChoiceDefault = YES;
                    imgModel.currentChoice = YES;
                    break;
                }
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    
    [self.collectionView reloadData];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeVoiceDefaultChoiceCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.isVoice = self.isVoice;
    merchentCell.index = indexPath.row;
    if(indexPath.row > 0){
        merchentCell.imgModel = self.dataArr[indexPath.row-1];
    }
    
    return merchentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self closeClick];
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.allowCrop = false;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [[NoticeTools getTopViewController] presentViewController:imagePicker animated:YES completion:nil];
        return;
    }
    for (NoticeVoiceDefaultImgModel *imgM in self.dataArr) {
        imgM.currentChoice = NO;
    }
    
    self.hasLocaChoice = YES;
    NoticeVoiceDefaultImgModel *currM = self.dataArr[indexPath.row-1];
    currM.currentChoice = YES;
    self.currentCoverId = currM.coverId;
    self.currentUrl = currM.cover_urls;
    [self.collectionView reloadData];
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count+1;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((DR_SCREEN_WIDTH-60)/3,(DR_SCREEN_WIDTH-60)/3);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10,20,10,20);
}


// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)setIsVoice:(BOOL)isVoice{
    _isVoice = isVoice;
}

- (void)sureClick{
    [[NoticeTools getTopViewController] showHUD];
    if(self.currentCoverId){
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"voiceCover/%@",self.currentCoverId] Accept:@"application/vnd.shengxi.v5.5.7+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if(success){
                self.hasLocaChoice = NO;
                if(self.imgCourIdBlock){
                    self.imgCourIdBlock(self.currentCoverId, self.currentUrl);
                }
                [self closeClick];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
    }else{
        [[NoticeTools getTopViewController] hideHUD];
        [self closeClick];
    }
}

- (void)dissMissTap{
    [self removeFromSuperview];
}


- (void)closeClick{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,self.contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    self.currentCoverId = nil;
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self hasLocaChoice];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.contentView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+50, DR_SCREEN_WIDTH,self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGesture) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if ([touchView isKindOfClass:[UIScrollView class]]) {
                self.scrollView = (UIScrollView *)touchView;
                self.isDragScrollView = YES;
                break;
            }else if (touchView == self.contentView) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = (UIView *)[touchView nextResponder];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGesture) {
        CGPoint point = [gestureRecognizer locationInView:self.contentView];
        if ([self.contentView.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    }else if (gestureRecognizer == self.panGesture) {
        return YES;
    }
    return YES;
}

// 是否与其他手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.contentView];
    if (self.isDragScrollView) {
        // 当UIScrollView在最顶部时，处理视图的滑动
        if (self.scrollView.contentOffset.y <= 0) {
            if (translation.y > 0) { // 向下拖拽
                self.scrollView.contentOffset = CGPointZero;
                self.scrollView.panGestureRecognizer.enabled = NO;
                self.isDragScrollView = NO;
                
                CGRect contentFrame = self.contentView.frame;
                contentFrame.origin.y += translation.y;
                self.contentView.frame = contentFrame;
            }
        }
    }else {
        
        CGFloat contentM = (self.frame.size.height - self.contentView.frame.size.height);
        if (translation.y > 0) { // 向下拖拽
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.y += translation.y;
            self.contentView.frame = contentFrame;
        }else if (translation.y < 0 && self.contentView.frame.origin.y > contentM) { // 向上拖拽
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.y = MAX((self.contentView.frame.origin.y + translation.y), contentM);
            self.contentView.frame = contentFrame;
        }
    }
    
    [panGesture setTranslation:CGPointZero inView:self.contentView];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGesture velocityInView:self.contentView];
        
        self.scrollView.panGestureRecognizer.enabled = YES;
        
        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
        if (velocity.y > 0 && self.lastTransitionY > 5 && !self.isDragScrollView) {
            [self closeClick];
        }else {
            [self show];
        }
    }
    
    self.lastTransitionY = translation.y;
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
    if(self.imgupBlock){
        self.imgupBlock(YES);
    }
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[NoticeTools getTopViewController] showHUD];
    NSString *pathMd5 =[NSString stringWithFormat:@"%ld_%@.jpg",arc4random()%999999999678999,[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"55" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:errorMessage forKey:@"coverUrl"];
            
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }else{
                [parm setObject:@"0" forKey:@"bucketId"];
            }
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voiceCover" Accept:@"application/vnd.shengxi.v5.5.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [[NoticeTools getTopViewController] hideHUD];
                if(success){
                    if(weakSelf.imgRefreshBlock){
                        weakSelf.imgRefreshBlock(YES);
                    }
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }else{
            [[NoticeTools getTopViewController] showToastWithText:errorMessage];
            [[NoticeTools getTopViewController] hideHUD];
        }
    }];
}

@end
