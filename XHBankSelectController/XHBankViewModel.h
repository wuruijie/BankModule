//
//  XHBankViewModel.h
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBankResponse.h"
#import "NSString+Transform.h"
#import "XHConstURl.h"
#import "XHMoneyBankResponse.h"
#import "XHRootBankController.h"
NS_ASSUME_NONNULL_BEGIN

@interface XHBankViewModel : NSObject
/*！
 获取所有开户银行
 */
+(void)getAllBaseBankInfoSuccess:(void (^)(XHBankResponse * responde))success failed:(void(^)(NSString *message))message;

// 获取排序后的通讯录列表
+ (NSMutableArray *) getContactListDataBy:(NSMutableArray *)array;
// 获取分区数(索引列表)
+ (NSMutableArray *) getContactListSectionBy:(NSMutableArray *)array;
/*！
 获取汇款银行讯息
 */
+(void)getTransMoneyBankInfoSuccess:(void(^)(NSArray * bankArray))bankArray failed:(void(^)(NSString * message))message;

/*！
 鉴权发送验证码(寻程)
 */
+(void)getMessageCodeForPayMoneyWithPhone:(NSString *)phone    Success:(void(^)(id success))success failed:(void(^)(NSString *message))message;
/*！
 银行卡鉴权(寻程)
 */
+(void)defineApiStoreForBankCardWithParams:(NSDictionary *)params Success:(void(^)(id success))success fialed:(void(^)(NSString *message))message;
/*！
 跳转到选择控件
 */
+(void)initRootBaseBankVcWithCurrentVc:(UIViewController *)vc;


@end

NS_ASSUME_NONNULL_END
