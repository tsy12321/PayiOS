//
//  MainViewController.m
//  CIPayiOS
//
//  Created by 卢良潇 on 16/5/30.
//  Copyright © 2016年 com.girl.123. All rights reserved.
//

#import "ViewController.h"

#import "PayApi.h"

@interface ViewController ()


@property(strong, nonatomic) UIScrollView *scrollview;

@property(strong, nonatomic) UITextView *AliTextView;

@property(strong, nonatomic) UITextView *WXTextView;

@property(assign, nonatomic) CGFloat offset;

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

@end

@implementation ViewController

#pragma mark - lift cycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //计算frame时y左边从0开始
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    //去掉返回按钮的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    
    [self initView];
}

#pragma mark - init

- (void)initView{
    
    self.title = @"支付Demo";
    
    UILabel * wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 10)];
    [ self.view addSubview:wxLabel];
    wxLabel.text = @"微信支付";
    wxLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _WXTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 100)];
    [_WXTextView setBackgroundColor:[UIColor grayColor]];
    [ self.view addSubview:_WXTextView];
    
    UIButton *wxBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 170, 100, 30)];
    [ self.view addSubview:wxBtn];
    [wxBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    [wxBtn setBackgroundColor:[UIColor grayColor]];
    wxBtn.tag = 2;
    [wxBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * alipayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, 100, 10)];
    [ self.view addSubview:alipayLabel];
    alipayLabel.text = @"支付宝支付";
    alipayLabel.textAlignment = NSTextAlignmentCenter;
    
    _AliTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 240, 300, 100)];
    [_AliTextView setBackgroundColor:[UIColor grayColor]];
    [ self.view addSubview:_AliTextView];
    
    UIButton *alipayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 360, 100, 30)];
    [ self.view addSubview:alipayBtn];
    [alipayBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [alipayBtn setBackgroundColor:[UIColor grayColor]];
    alipayBtn.tag = 1;
    [alipayBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == 1) {     //支付宝支付
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
    }else if (btn.tag == 2){    //微信支付
        [[PayApi sharedApi]wxPayWithPayParam:_WXTextView.text success:^(void) {
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
    }
}

@end
