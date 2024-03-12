/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+MultiFormat.h"
#import "SDImageCodersManager.h"

@implementation UIImage (MultiFormat)

+(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (nullable UIImage *)sd_imageWithData:(nullable NSData *)data {
    return [self sd_imageWithData:data scale:1];
}

+ (nullable UIImage *)sd_imageWithData:(nullable NSData *)data scale:(CGFloat)scale {
    return [self sd_imageWithData:data scale:scale firstFrameOnly:NO];
}

+ (nullable UIImage *)sd_imageWithData:(nullable NSData *)data scale:(CGFloat)scale firstFrameOnly:(BOOL)firstFrameOnly {
    if (!data) {
        return nil;
    }
    SDImageCoderOptions *options = @{SDImageCoderDecodeScaleFactor : @(MAX(scale, 1)), SDImageCoderDecodeFirstFrameOnly : @(firstFrameOnly)};
    return [[SDImageCodersManager sharedManager] decodedImageWithData:data options:options];
}

- (nullable NSData *)sd_imageData {
    return [self sd_imageDataAsFormat:SDImageFormatUndefined];
}

- (nullable NSData *)sd_imageDataAsFormat:(SDImageFormat)imageFormat {
    return [self sd_imageDataAsFormat:imageFormat compressionQuality:1];
}

- (nullable NSData *)sd_imageDataAsFormat:(SDImageFormat)imageFormat compressionQuality:(double)compressionQuality {
    return [self sd_imageDataAsFormat:imageFormat compressionQuality:compressionQuality firstFrameOnly:NO];
}

- (nullable NSData *)sd_imageDataAsFormat:(SDImageFormat)imageFormat compressionQuality:(double)compressionQuality firstFrameOnly:(BOOL)firstFrameOnly {
    SDImageCoderOptions *options = @{SDImageCoderEncodeCompressionQuality : @(compressionQuality), SDImageCoderEncodeFirstFrameOnly : @(firstFrameOnly)};
    return [[SDImageCodersManager sharedManager] encodedDataWithImage:self format:imageFormat options:options];
}

@end
