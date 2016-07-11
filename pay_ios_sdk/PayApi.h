//
//  PayApi.h
//  PayDemo
//
//  Created by Tsy on 16/7/11.
//  Copyright © 2016年 Tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayApi : NSObject

typedef NS_ENUM(NSInteger, PayErrorCode) {
    
    WXERROR_PAYPARAM            = 1002,   //支付参数解析错误
    WXERROR_NOTINSTALL          = 1003,   //未安装微信
    WXERROR_PAY                 = 1004,   //支付失败
    WXCANCEL_PAY                = 1005,   //支付取消
    
    ALIPAYERROR_SCHEME          = 1101,     //scheme错误
    ALIPAYERROR_PAY             = 1102,     //支付错误
    ALIPAYCANCEL_PAY            = 1103      //支付取消
};

/**
 *  获取单例
 */
+ (instancetype)sharedApi;

/**
 *  发起支付宝支付请求
 *
 *  @param pay_param    支付
 *  @param successBlock 成功
 *  @param failBlock    失败
 */
- (void)alipayWithPayParam:(NSString *)pay_param
                   success:(void (^)(void))successBlock
                   failure:(void (^)(NSInteger))failBlock;

/**
 *  发起微信支付请求
 *
 *  @param pay_param    支付参数
 *  @param successBlock 成功
 *  @param failBlock    失败
 */
- (void)wxPayWithPayParam:(NSString *)pay_param
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSInteger))failBlock;

/**
 *  回调入口
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
- (BOOL) handleOpenURL:(NSURL *) url;

@end
