//
//  XHBankViewModel.m
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/23.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import "XHBankViewModel.h"

#import <UIKit/UIKit.h>
@implementation XHBankViewModel

+(void)initRootBaseBankVcWithCurrentVc:(UIViewController *)vc {
    XHRootBankController *root =[[XHRootBankController alloc] init];
    root.hidesBottomBarWhenPushed = YES;
    root.delegete =(id)vc;
    [vc.navigationController pushViewController:root animated:YES];
    
}
+(void)getAllBaseBankInfoSuccess:(void (^)(XHBankResponse * _Nonnull))success failed:(void (^)(NSString * _Nonnull))message {
    [YTCommoneService getNewWithParam:nil url:kGetBaseBank success:^(__kindof FLBaseRequest * _Nonnull request) {
        XHBankResponse * res =[XHBankResponse mj_objectWithKeyValues:request.responseJSONObject];
        if (res.code ==200) {
            success(res);
        }else {
            message(res.message);
        }
    } failure:^(__kindof FLBaseRequest * _Nonnull request) {
        message(@"网络不给力");
    }];
}

+(void)getTransMoneyBankInfoSuccess:(void (^)(NSArray * _Nonnull))bankArray failed:(void (^)(NSString * _Nonnull))message {
    [YTCommoneService postNewWithParam:@{@"token":[FYAccountTool localAccount].token} url:kGetMoneyBank success:^(__kindof FLBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        if (code ==200) {
            bankArray(dic[@"result"]);
        }else {
            message(dic[@"message"]);
        }
    } failure:^(__kindof FLBaseRequest * _Nonnull request) {
        message(@"网络不给力");
    }];
 
}
/**
 获取验证码
 */
+(void)getMessageCodeForPayMoneyWithPhone:(NSString *)phone Success:(void (^)(id success))success failed:(void (^)(NSString * _Nonnull))message {
    [YTCommoneService postNewWithParam:@{@"token":[FYAccountTool localAccount].token,@"p_mobileno":phone} url:kGgetMoneyBankMessageCode success:^(__kindof FLBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        if (code ==200) {
            success(dic);
        }else {
            message(dic[@"message"]);
        }
    } failure:^(__kindof FLBaseRequest * _Nonnull request) {
        message(@"网络不给力");
    }];
}
/**
 银行卡q鉴权 寻程
 */
+(void)defineApiStoreForBankCardWithParams:(NSDictionary *)params Success:(void (^)(id _Nonnull))success fialed:(void (^)(NSString * _Nonnull))message {
    [YTCommoneService postNewWithParam:params url:kDefineMoneyBankMessagecode success:^(__kindof FLBaseRequest * _Nonnull request) {
        XHMoneyBankResponse *resonse =[XHMoneyBankResponse mj_objectWithKeyValues:request.responseObject];
        if (resonse.code == 200) {
             success(resonse);
        }else {
            message(resonse.message);
        }
    } failure:^(__kindof FLBaseRequest * _Nonnull request) {
        message(@"网络不给力");
    }];
}
/**
 联系人数组排序
 
 @param array 原始联系人数组数据
 @return 排序后的联系人数组
 */
+ (NSMutableArray *) getContactListDataBy:(NSMutableArray *)array{
    
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = [((XHCommonResult *)obj1).bank_name transformCharacter];
        NSString *strB = [((XHCommonResult *)obj2).bank_name transformCharacter];
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (XHCommonResult *contact in serializeArray) {
        char c = [[contact.bank_name transformCharacter] characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:contact];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:contact];
        }
        else {
            [data addObject:contact];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}


/**
 获取分区数(姓氏首字母)
 
 @param array 排序后的联系人数组
 @return [A,B,C,D.....]
 */
+ (NSMutableArray *)getContactListSectionBy:(NSMutableArray *)array {
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:UITableViewIndexSearch]; // 索引栏最上方的搜索icon
    for (NSArray *item in array) {
        XHCommonResult *model = [item objectAtIndex:0];
        char c = [[model.bank_name transformCharacter] characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}


@end
