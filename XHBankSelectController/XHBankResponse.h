//
//Created by ESJsonFormatForMac on 19/04/18.
//

#import <Foundation/Foundation.h>

@class XHCommonResult;
@interface XHBankResponse : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray* result;

@property (nonatomic, assign) NSInteger code;

@end
@interface XHCommonResult : NSObject
/**
 银行编号
 **/
@property (nonatomic, copy) NSString *bankserial;
/**
 银行名称
 **/
@property (nonatomic, copy) NSString *bank_name;
/**
 限额信息
 **/
@property (nonatomic, copy) NSString *quota;
/**
 银行logo
 **/
@property (nonatomic, copy)NSString *bankimage;
/**
 是否是常用的16家银行
 **/
@property (nonatomic, assign)BOOL isBaseBank;

@end

