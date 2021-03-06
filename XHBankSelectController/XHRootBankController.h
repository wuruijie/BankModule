//
//  XHRootBankController.h
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "XHSearchBankController.h"
#import "XHBaseBankController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol XHGetBankInfoDelegete <NSObject>

-(void)getBankInfo:(XHCommonResult *)model;

@end

@interface XHRootBankController : UIViewController

@property (nonatomic, strong)XHBaseBankController * baseBank;

@property (nonatomic, strong)XHSearchBankController *searchBank;

@property (nonatomic, weak)id <XHGetBankInfoDelegete> delegete;


@end

NS_ASSUME_NONNULL_END
