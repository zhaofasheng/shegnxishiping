//
//  NoticeEditCard1Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditCard1Cell.h"
#import "NoticeWallCollectionViewCell.h"

#import "NoticePreViewPhoto.h"
@implementation NoticeEditCard1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];

    
        [self initCollectionView];
    }
    return self;
}

- (void)setHeight:(CGFloat)height{
    _height = height;
    self.collectionView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40,height);
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    
    [self.collectionView reloadData];
}

- (void)initCollectionView {
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40,self.frame.size.height-12) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[NoticeWallCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.contentView addSubview:self.collectionView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.shopModel.myShopM.photowallArr.count) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = NO;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = NO;
        imagePicker.showPhotoCannotSelectLayer = YES;
        imagePicker.allowCrop = NO;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePicker.showSelectBtn = YES;
        [[NoticeTools getTopViewController] presentViewController:imagePicker animated:YES completion:nil];
    }else{
        NoticeShopDataIdModel *firstM = self.shopModel.myShopM.photowallArr[indexPath.row];
        NoticeWallCollectionViewCell *cell = (NoticeWallCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = cell.postImageView;
        item.largeImageURL     = [NSURL URLWithString:firstM.photo_url];

        NSMutableArray *arr = [NSMutableArray new];
        [arr addObject:item];
        YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
        UIView *toView         = [UIApplication sharedApplication].keyWindow;
        [photoView presentFromImageView:cell.postImageView toContainer:toView animated:YES completion:nil];

    }
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (PHAsset *photoAsset in assets) {
        TZAssetModel *assestModel = [[TZAssetModel alloc] init];
        assestModel.asset = photoAsset;
        [arr addObject:assestModel];
    }
    NoticePreViewPhoto *_photoPreView = [[NoticePreViewPhoto alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    __weak typeof(self) weakSelf = self;
    _photoPreView.isOnlyOne = YES;
    _photoPreView.getPhotosBlock = ^(NSMutableArray * _Nonnull photos) {
        TZAssetModel *assestM = photos[0];
        if(assestM.cropImage){//裁剪过图片
            [weakSelf upLoadHeader:assestM.cropImage path:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999] withDate:nil];
            return;
        }
        
        PHAsset *asset = assestM.asset;
        if(!asset){
            return;
        }
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [[NoticeTools getTopViewController] showToastWithText:@"获取文件失败"];
                return ;
            }
            [weakSelf upLoadHeader:[UIImage imageWithData:imageData] path:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999] withDate:nil];
        }];
    };
    _photoPreView.models = arr;
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    //获取七牛token
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"87" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    [[NoticeTools getTopViewController] showHUD];
    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:errorMessage forKey:@"wall_url"];
            
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
                 
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


//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeWallCollectionViewCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    merchentCell.addPhotosButton.hidden = YES;
    if (indexPath.row < self.shopModel.myShopM.photowallArr.count) {
        merchentCell.photoModel = self.shopModel.myShopM.photowallArr[indexPath.row];
    }
    if (indexPath.row == self.shopModel.myShopM.photowallArr.count){
        merchentCell.addPhotosButton.hidden = NO;
    }
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (self.shopModel.myShopM.photowallArr.count < 10) ? (self.shopModel.myShopM.photowallArr.count+1) : self.shopModel.myShopM.photowallArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-40-20)/4,(DR_SCREEN_WIDTH-40-20)/4);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 4, 4,4);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
