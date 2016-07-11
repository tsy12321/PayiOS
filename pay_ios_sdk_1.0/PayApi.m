//
//  支付二次封装
//  PayDemo
//
//  Created by Tsy on 16/7/11.
//  Copyright © 2016年 Tsy. All rights reserved.
//

#import "PayApi.h"

#import "lib/Wechat_SDK_1.6.2/WXApi.h"

@interface PayApi()<WXApiDelegate>

@property (nonatomic, copy) void(^WXPaySuccess)();
@property (nonatomic, copy) void(^WXPayError)(NSInteger err_code);

@end

@implementation PayApi

static id _instance;

+ (instancetype)sharedApi {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PayApi alloc] init];
    });
    
    return _instance;
}

//回调处理
- (BOOL) handleOpenURL:(NSURL *) url{
    return [WXApi handleOpenURL:url delegate:self];
}

//微信支付
- (void)wxPayWithPayParam:(NSString *)pay_param
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSInteger))failBlock {
    self.WXPaySuccess = successBlock;
    self.WXPayError = failBlock;
    
    //解析结果
    NSData *data = [pay_param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSString *appid = dic[@"appid"];
    NSString *partnerid = dic[@"partnerid"];
    NSString *prepayid = dic[@"prepayid"];
    NSString *package = dic[@"package"];
    NSString *noncestr = dic[@"noncestr"];
    NSString *timestamp = dic[@"timestamp"];
    NSString *sign = dic[@"sign"];
    
    if(error != nil) {
        failBlock(WXERROR_PAYPARAM);
        return ;
    }
    
    [WXApi registerApp:appid];
    
    if(![WXApi isWXAppInstalled]) {
        failBlock(WXERROR_NOTINSTALL);
        return ;
    }
    
    //发起微信支付
    PayReq* req   = [[PayReq alloc] init];
    req.partnerId = partnerid;
    req.prepayId  = prepayid;
    req.nonceStr  = noncestr;
    req.timeStamp = timestamp.intValue;
    req.package   = package;
    req.sign      = sign;
    [WXApi sendReq:req];
}

#pragma mark - 微信回调

- (void)onResp:(BaseResp *)resp{
    NSLog(@"onResp");
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        
        switch (response.errCode) {
            case WXSuccess:
                self.WXPaySuccess();
                break;
                
            case WXErrCodeUserCancel:   //用户点击取消并返回
                self.WXPayError(WXCANCEL_PAY);
                break;

            default:        //剩余都是支付失败
                self.WXPayError(WXERROR_PAY);
                break;
        }
    }
}


@end
