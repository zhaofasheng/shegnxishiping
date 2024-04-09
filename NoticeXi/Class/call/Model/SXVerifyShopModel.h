//
//  SXVerifyShopModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXVerifyShopModel : NSObject

@property (nonatomic, strong) NSString *real_name;//真实姓名
@property (nonatomic, strong) NSString *cert_no;//身份证号
@property (nonatomic, strong) NSString *front_photo_url;//身份证正面照
@property (nonatomic, strong) NSString *back_photo_url;//身份证反面照
@property (nonatomic, strong) NSString *authentication_type;//认证类型(1学历认证 2职业认证 3资格证认证)
@property (nonatomic, strong) NSString *education_option;//学历(1本科在读 2本科 3硕士在读 4硕士 5博士在读 6博士)
@property (nonatomic, strong) NSString *education_optionName;
@property (nonatomic, strong) NSString *education_img_url;//学历认证照片
@property (nonatomic, strong) NSString *school_name;//学校名称
@property (nonatomic, strong) NSString *speciality_name;//专业名称
@property (nonatomic, strong) NSString *industry_name;//行业名称
@property (nonatomic, strong) NSString *position_name;//职位名称
@property (nonatomic, strong) NSString *credentials_name;//资格证名称
@property (nonatomic, strong) NSString *credentials_img_url;//资格证照片
@property (nonatomic, strong) NSString *verify_status;//2已提交,待审核 3审核通过 4审核失败

@property (nonatomic, strong) NSArray *career_images_url;//职业认知照片
@end

NS_ASSUME_NONNULL_END
