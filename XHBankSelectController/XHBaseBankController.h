//
//  XHBaseBankController.h
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "FLBaseViewController.h"
#import "XHBankResponse.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ChoiseBankDelegete <NSObject>

-(void)selectRowModel:(XHCommonResult *)model;

@end

@interface XHBaseBankController : FLBaseViewController

@property (nonatomic, weak)id <ChoiseBankDelegete>delegete;

@end

NS_ASSUME_NONNULL_END
