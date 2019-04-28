//
//  XHMoneyBankResponse.h
//  XinHuWealth
//
//  Created by XinHuiOS on 2019/4/25.
//  Copyright © 2019 张彦芳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHBankInfo,XHBankInformation;
NS_ASSUME_NONNULL_BEGIN

@interface XHMoneyBankResponse : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) XHBankInfo* result;

@property (nonatomic, assign) NSInteger code;

@end

@interface XHBankInfo : NSObject
/**
 银行编号
 **/
@property (nonatomic, copy) NSString *bankcard;
/**
 银行名称
 **/
@property (nonatomic, copy) NSString *realName;
/**
 限额信息
 **/
@property (nonatomic, copy) NSString *cardNo;
/**
 银行logo
 **/
@property (nonatomic, copy)NSString *mobile;
/**
 是否是常用的16家银行 不确定类型。
// 6214835891877357 招商认证不通过
 **/
@property (nonatomic, strong)XHBankInformation * information;

@end

@interface  XHBankInformation : NSObject


//"bankname": "中国建设银行",
//"banknum": "1050000",
//"cardprefixnum": "622700",
//"cardname": "龙卡储蓄卡(银联卡)",
//"cardtype": "银联借记卡",
//"cardprefixlength": 6,
//"isLuhn": true,
//"iscreditcard": 1,
//"cardlength": 19,
//"bankurl": "http://www.ccb.com/",
//"enbankname": "China Construction Bank",
//"abbreviation": "CCB",
//"bankimage": "http://auth.apis.la/bank/2_CCB.png",
//"servicephone": "95533"
@property (nonatomic, copy)NSString * bankname;

@property (nonatomic, copy)NSString * banknum;
@property (nonatomic, copy)NSString *cardprefixnum;
@property (nonatomic, copy)NSString *cardname;
@property (nonatomic, copy)NSString *cardtype;
@property (nonatomic, assign)NSInteger  cardprefixlength;
@property (nonatomic, assign)BOOL  isLuhn;
@property (nonatomic, assign)NSInteger iscreditcard;
@property (nonatomic, assign)NSInteger cardlength;

@property (nonatomic, copy)NSString *bankurl;
@property (nonatomic, copy)NSString *enbankname;
@property (nonatomic, copy)NSString *abbreviation;
@property (nonatomic, copy)NSString *bankimage;
@property (nonatomic, copy)NSString *servicephone;
@end










NS_ASSUME_NONNULL_END
