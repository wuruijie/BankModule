//
//  XHMoneyBankResponse.m
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/25.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "XHMoneyBankResponse.h"

@implementation XHMoneyBankResponse

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"result" : [XHBankInfo class]};
}

@end

@implementation XHBankInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"information" : [XHBankInformation class]};
}

@end

@implementation XHBankInformation


@end

