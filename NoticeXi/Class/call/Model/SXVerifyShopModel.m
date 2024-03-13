//
//  SXVerifyShopModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVerifyShopModel.h"

@implementation SXVerifyShopModel

- (void)setEducation_option:(NSString *)education_option{
    _education_option = education_option;
    //(1本科在读 2本科 3硕士在读 4硕士 5博士在读 6博士)
    if (education_option.intValue == 1) {
        self.education_optionName = @"在读";
    }else if (education_option.intValue == 2){
        self.education_optionName = @"本科";
    }else if (education_option.intValue == 3){
        self.education_optionName = @"硕士在读";
    }else if (education_option.intValue == 4){
        self.education_optionName = @"硕士";
    }else if (education_option.intValue == 5){
        self.education_optionName = @"博士在读";
    }else if (education_option.intValue == 6){
        self.education_optionName = @"博士";
    }
}

@end
