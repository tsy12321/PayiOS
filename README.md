# PayiOS
对微信支付和支付宝支付的App端SDK进行二次封装，对外提供一个较为简单的接口和支付结果回调

## 1 下载最新SDK

下载后将sdk放入项目目录中

## 2 配置

### 2.1 配置静态库

在项目General-linked Frameworks and Libraries中添加以下库：

 - SystemConfiguration.framework
 - libsqlite3.tbd
 - libc++.tbd
 - libz.tbd
 - libWeChatSDK.a(在下载的SDK中添加)
 - QuartzCore.framework
 - CoreText.framework
 - CoreGraphic.framework
 - UIKit.framework
 - Foundation.framework
 - CFNetwork.framework
 - CoreMotion.framework
 - AlipaySDK.framework(在下载的SDK中添加)

### 2.2 配置应用白名单
 针对 iOS 9 系统更新， 为了使你接入的微信支付与支付宝支付兼容 iOS 9 ,请按照以下引导进行操作： 应用需要在 Info.plist 中将要使用的 URL Schemes 列为白名单，才可正常检查其他应用是否安装，需要在 Info.plist 里添加如下代码：
 
 ```xml
 	<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>wechat</string>
        <string>weixin</string>
        <string>alipay</string>
    </array>
 ```
 
### 2.3 配置URL Types
 为了用户操作完成后能够跳转回你的应用，请务必添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 TARGETS 一栏，在 Info 标签栏的 URL Types 添加 URL Schemes,或在info.plist中右键选择open as，选择Source code，找到如下代码并设置
 
 ```xml
 <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>alipay</string>   
                         <!-- 支付宝支付-->
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.girl.123</string>
                                 <!-- 此处填写app的Bundle Identity-->
            </array>
        </dict>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>weixin</string>
                        <!-- 微信支付-->
            <key>CFBundleURLSchemes</key>
            <array>
                <string>wx6b69bdbf2adca4f8</string>
                                <!-- 此处填写申请的微信app id-->
            </array>
        </dict>
    </array>
 ```
 
### 2.4 开启http访问
 针对 iOS 9 限制 http 协议的访问，如果 App 需要访问 http://， 则需要在 Info.plist 添加如下代码:
 
 ```xml
 <key>NSAppTransportSecurity</key>
	<dict>
    	<key>NSAllowsArbitraryLoads</key>
    	<true/>
	</dict>
 ```
 
### 2.5 设置build-setting 中 bitcode为NO
 
### 2.6 设置 Search Paths

进入 Build Settings-Search Paths
将Framework Search Paths、Header Search Paths、Library Search Paths里面增加lib里面微信SDK路径和支付宝SDK路径：

例如：（相对路径要自己设置）

- "$(SRCROOT)/../pay_ios_sdk/lib/Wechat_SDK_1.6.2"
- "$(SRCROOT)/../pay_ios_sdk/lib/aliPay_SDK_2.0"

## 3 调用
 
### 3.1 接收交易结果设置
 
 在AppDelegate.m文件中添加以下代码：
 
 ```objective-c
 	#import "PayApi.h"
 	
 	...
 	
 	- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    	return [[PayApi sharedApi] handleOpenURL:url];
	}

	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    	return [[PayApi sharedApi] handleOpenURL:url];
	}
 ```
 
### 3.2 发起支付调用
 
#### 3.2.1 微信支付
 
 ```objective-c
 
 	//pay_param是服务端生成的支付参数
 	[[PayApi sharedApi]wxPayWithPayParam:pay_param success:^(void) {
            NSLog(@"支付成功");
        } failure:^(PayErrorCode err_code) {
            switch (err_code) {
                case WXERROR_PAYPARAM:      //支付参数错误
                    NSLog(@"支付参数错误");
                    break;
                case WXERROR_PAY:   //支付失败
                    NSLog(@"支付失败");
                    break;
                case WXCANCEL_PAY:      //支付取消
                    NSLog(@"支付取消");
                    break;
                    
                default:
                    break;
            }
        }];

 ```
 
#### 3.2.2 支付宝支付
```objective-c
	[[PayApi sharedApi]alipayWithPayParam:_AliTextView.text success:^(void){
            NSLog(@"支付成功");
        } failure:^(PayErrorCode err_code) {
            switch (err_code) {
                case ALIPAYERROR_PAY:   //支付失败
                    NSLog(@"支付失败");
                    break;
                case ALIPAYCANCEL_PAY:      //支付取消
                    NSLog(@"支付取消");
                    break;
    				
                default:
                    break;
            }

        }];
``

### 欢迎关注我的公众号

![我的公众号](http://upload-images.jianshu.io/upload_images/1594931-a5b65451c706c2cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
