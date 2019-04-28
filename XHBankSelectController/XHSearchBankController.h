//
//  XHSearchBankController.h
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "FLBaseViewController.h"
#import "XHBankResponse.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SearchBankDelegete <NSObject>

-(void)getBankInfo:(XHCommonResult *)model;

@end

@interface XHSearchBankController : FLBaseViewController

-(void)cancelClick;
@property (nonatomic, weak)id <SearchBankDelegete> delegete;


@end

NS_ASSUME_NONNULL_END
