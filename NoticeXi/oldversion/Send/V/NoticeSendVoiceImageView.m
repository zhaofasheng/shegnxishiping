//
//  NoticeSendVoiceImageView.m
//  NoticeXi
//
//  Created by li lei on 2023/11/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendVoiceImageView.h"
#import "NSData+ImageContentType.h"
#import <SDWebImage/UIImage+GIF.h>
@implementation NoticeSendVoiceImageView
{
    UIImageView *_imgV1;
    UIImageView *_imgV2;
    UIImageView *_imgV3;
    NSMutableArray *_photosItemArr;
    NSMutableArray *_photosArr;
    NSMutableArray *_mbArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        _photosArr = [NSMutableArray new];
        
        _mbArr = [NSMutableArray new];

        CGFloat width = (DR_SCREEN_WIDTH-40-10)/3;
        
        for (int i = 0; i < 3; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)*i,0, width, width)];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            imageV.tag = i;
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageLook:)];
            [imageV addGestureRecognizer:tap0];
            imageV.hidden = YES;

            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageV.frame.size.width-20-4, 4, 20, 20)];
            [closeBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
            [imageV addSubview:closeBtn];
            closeBtn.tag = i;
            [closeBtn addTarget:self action:@selector(removeImgWith:) forControlEvents:UIControlEventTouchUpInside];
            closeBtn.hidden = YES;
            if (i == 0) {
                self.closeBtn0 = closeBtn;
                _imgV1 = imageV;
            }else if (i == 1){
                self.closeBtn1 = closeBtn;
                _imgV2 = imageV;
            }else{
                self.closeBtn2 = closeBtn;
                _imgV3 = imageV;
            }
            [_photosArr addObject:imageV];
            [self addSubview:imageV];
        }

        _photosItemArr = [NSMutableArray new];

    }
    
    return self;
}

- (void)setIsVoice:(BOOL)isVoice{
    _isVoice = isVoice;
    if(isVoice){
        self.choiceButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.choiceButton setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    }
}

- (void)choiceImage{
    if(self.choiceBlock){
        self.choiceBlock(YES);
    }
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)removeImgWith:(UIButton *)button{
    if (self.imgBlock) {
        self.imgBlock(button.tag);
    }
}


- (void)setIsLocaImage:(BOOL)isLocaImage{
    _isLocaImage = isLocaImage;
    if (isLocaImage) {
        self.closeBtn0.hidden = NO;
        self.closeBtn1.hidden = NO;
        self.closeBtn2.hidden = NO;
    }
}


- (void)bigImageLook:(UITapGestureRecognizer *)tap{
 
    UIImageView *tapView = (UIImageView *)tap.view;

    
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:_photosItemArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:tapView
                   toContainer:toView
                      animated:YES completion:nil];
}


- (void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
    self.choiceButton.hidden = imgArr.count?YES:NO;
    for (int i = 0; i < _photosArr.count;i++) {
        UIImageView *imageav = _photosArr[i];
        imageav.hidden = YES;
    }

    if (imgArr.count == 1){
        _imgV1.hidden = NO;
        [_photosItemArr removeAllObjects];
        
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        if (self.isLocaImage) {
            _imgV1.image = [UIImage sd_imageWithGIFData:[imgArr[0] objectForKey:@"ImageDatas"]];
        }else{
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            item.largeImageURL     = [NSURL URLWithString:[NoticeTools hasChinese:array[0]]];

           
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
                [_imgV1  sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
                
            }

        }

        [_photosItemArr addObject:item];
    }else if (imgArr.count == 2){
        _imgV1.hidden = NO;
        _imgV2.hidden = NO;
        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _imgV2;
        
        if (self.isLocaImage) {
            _imgV1.image = [UIImage sd_imageWithGIFData:[imgArr[0] objectForKey:@"ImageDatas"]];
            _imgV2.image = [UIImage sd_imageWithGIFData:[imgArr[1] objectForKey:@"ImageDatas"]];
        }else{
            SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
            
                [_imgV1  sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
                
            }
      
            if ([imgArr[1] containsString:@".gif"] || [imgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
            
                [_imgV2  sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
                
            }
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [imgArr[1] componentsSeparatedByString:@"?"];
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
        }

        
        [_photosItemArr addObject:item];
        [_photosItemArr addObject:item1];
    }else if (imgArr.count == 3){
        _imgV1.hidden = NO;
        _imgV2.hidden = NO;
        _imgV3.hidden = NO;
        [_photosItemArr removeAllObjects];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _imgV1;
        
        YYPhotoGroupItem *item1 = [YYPhotoGroupItem new];
        item1.thumbView         = _imgV2;
        
        YYPhotoGroupItem *item2 = [YYPhotoGroupItem new];
        item2.thumbView         = _imgV3;

        if (self.isLocaImage) {
            _imgV1.image = [UIImage sd_imageWithGIFData:[imgArr[0] objectForKey:@"ImageDatas"]];
            _imgV2.image = [UIImage sd_imageWithGIFData:[imgArr[1] objectForKey:@"ImageDatas"]];
            _imgV3.image = [UIImage sd_imageWithGIFData:[imgArr[2] objectForKey:@"ImageDatas"]];
        }else{
            NSArray *array = [imgArr[0] componentsSeparatedByString:@"?"];
            NSArray *array2 = [imgArr[1] componentsSeparatedByString:@"?"];
            
            NSArray *array3 = [imgArr[2] componentsSeparatedByString:@"?"];
            SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
            if ([imgArr[0] containsString:@".gif"] || [imgArr[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV1 setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
            
                [_imgV1  sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
                
            }
      
            if ([imgArr[1] containsString:@".gif"] || [imgArr[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV2 setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
            
                [_imgV2  sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
                
            }
            if ([imgArr[2] containsString:@".gif"] || [imgArr[2] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_imgV3 setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
            
                [_imgV3  sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
                
            }
            
            item.largeImageURL     = [NSURL URLWithString:array[0]];
            item1.largeImageURL     = [NSURL URLWithString:array2[0]];
            item2.largeImageURL     = [NSURL URLWithString:array3[0]];
            
        }
        [_photosItemArr addObject:item];
        [_photosItemArr addObject:item1];
        [_photosItemArr addObject:item2];
    }
}

@end
