//
//  WebViewController.m
//  DashBoardSG
//
//  Created by Võ Duy Hùng  on 5/30/16.
//  Copyright © 2016 Võ Duy Hùng . All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
@interface WebViewController ()<MBProgressHUDDelegate ,UIWebViewDelegate>{
    UIActivityIndicatorView * activity;
    MBProgressHUD *hud;
}
@end
@implementation WebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //Cấu hình cookie và load request lên web.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]}];
    NSString *cookie_value = [[NSUserDefaults standardUserDefaults] objectForKey:@"valuecc"];
    NSString *cookie_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"namecc"];
    NSMutableDictionary *dictCookieID = [NSMutableDictionary dictionary];
    [dictCookieID setObject:cookie_name forKey:NSHTTPCookieName];
    [dictCookieID setObject:cookie_value forKey:NSHTTPCookieValue];
    [dictCookieID setObject:@"https://cms.sungroup.com.vn" forKey:NSHTTPCookieDomain];
    [dictCookieID setObject:@"https://cms.sungroup.com.vn/bao-cao/doanh_thu_tuc_thoi" forKey:NSHTTPCookieOriginURL];
    [dictCookieID setObject:@"/" forKey:NSHTTPCookiePath];
    [dictCookieID setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookieID = [NSHTTPCookie cookieWithProperties:dictCookieID];
    NSArray *cookies = [NSArray arrayWithObjects: cookieID,nil];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieID];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSString* url = @"https://cms.sungroup.com.vn/bao-cao/doanh_thu_tuc_thoi";
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2629743];
    [request setHTTPShouldHandleCookies:YES];
    
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [(NSMutableURLRequest *)request setAllHTTPHeaderFields:headers];
    
    [_web loadRequest:request];
    
    // BUTTON LOGO DASHBOARD
    UIImage *imageForSetting = [UIImage imageNamed:@"120x120.png"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.bounds = CGRectMake(0, 0, 30, 30);
    [settingButton setEnabled:YES];
    [settingButton setImage:imageForSetting forState:UIControlStateNormal];
    UIBarButtonItem *sttButton= [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    // LABLE SG DASHBOARD
    UILabel *lbl_Dashboard = [[UILabel alloc]init];
    lbl_Dashboard.frame = CGRectMake(0, 0, 200, 20);
    lbl_Dashboard.text =@"Sun Group Reports";
    [lbl_Dashboard setTextAlignment:NSTextAlignmentLeft];
    lbl_Dashboard.textColor = [UIColor whiteColor];
    [lbl_Dashboard setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    UIBarButtonItem *menuItemButton= [[UIBarButtonItem alloc] initWithCustomView:lbl_Dashboard];
    NSArray *arrayButtonLeft= [[NSArray alloc] initWithObjects:sttButton,menuItemButton, nil];
    self.navigationItem.leftBarButtonItems=arrayButtonLeft;
    
    
    //BUTTON REFRESH
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"144"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(0, 0, 25, 25);
    [refreshButton addTarget:self action:@selector(refreshButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barRefresh= [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    //BUTTON LOGOUT
    UIButton *btn_Logout =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_Logout setImage:[UIImage imageNamed:@"Dangxuat"] forState:UIControlStateNormal];
    [btn_Logout setFrame:CGRectMake(0, 0, 20, 20)];
    [btn_Logout addTarget:self action:@selector(ButtonLogout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton_Logout = [[UIBarButtonItem alloc] initWithCustomView:btn_Logout];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 30;
    NSArray *arrayButtonRight= [[NSArray alloc] initWithObjects:barButton_Logout,spacer,barRefresh, nil];
    self.navigationItem.rightBarButtonItems = arrayButtonRight;

    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.labelText = @"Đang tải dữ liệu...";
    hud.dimBackground = YES;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    [self.view addSubview:hud] ;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [hud show:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hide:YES];
    //hide các thẻ div trong webview
    [_web stringByEvaluatingJavaScriptFromString:@"hiddenElement()"];
  }
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud show:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)refreshButton:(id)sender {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.labelText = @"Đang tải dữ liệu...";
    hud.dimBackground = YES;
    [_web reload];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    [self.view addSubview:hud] ;
}
- (IBAction)ButtonLogout:(id)sender {
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Bạn có muốn đăng xuất tài khoản!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Đăng xuất", "OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"valuecc"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"namecc"];
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"logout1"];
        [self presentViewController:login animated:YES completion:nil];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"Không", "OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancle];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
