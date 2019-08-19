//
//  LoginViewController.m
//  DashBoardSG
//
//  Created by Võ Duy Hùng  on 5/11/16.
//  Copyright © 2016 Võ Duy Hùng . All rights reserved.
//

#import "LoginViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()<MBProgressHUDDelegate,UITextFieldDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSString *strSessName,*strSessVal;
    MBProgressHUD *hud;
}

@end
#define IS_IPHONE6PLUS (([[UIScreen mainScreen] bounds].size.width) ==414.0f && ([[UIScreen mainScreen] bounds].size.height) ==736.0f)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.width) ==375.0f && ([[UIScreen mainScreen] bounds].size.height) ==667.0f)
#define IS_IPHONE5S (([[UIScreen mainScreen] bounds].size.width) ==320.0f && ([[UIScreen mainScreen] bounds].size.height) ==568.0f)
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.width) ==320.0f && ([[UIScreen mainScreen] bounds].size.height) ==480.0f)
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work,no internet connection
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Không có kết nối Internet.Hãy bật WIFI hoặc 3G để ứng dụng hoạt động!"  delegate:self cancelButtonTitle:@"Xác nhận"  otherButtonTitles:nil];
        [myAlert show];
    }
    else{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *saveUsername = [def stringForKey:@"textField1Text"];
    NSString *savePassword = [def stringForKey:@"textField2Text"];
    //Save usernae+password
    _User.text=saveUsername; _Pass.text=savePassword;
    }
    [self interface];
    
    //Create Progress
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = @"Đang tải dữ liệu...";
    hud.detailsLabelText = @"Vui lòng chờ trong giây lát";
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    [self.view addSubview:hud] ;
}

-(void)interface{
    
    UIView * containterTK = [[UIView alloc]init];
    [containterTK setFrame:CGRectMake(0.0f, 0.0f, 45.0f, 23.0f)];
    
    UIImageView *iconTK= [[UIImageView alloc] init];
    [iconTK setImage:[UIImage imageNamed:@"User60.png"]];
    [iconTK setFrame:CGRectMake(10.0f, 0.0f, 23.0f, 23.0f)];
    [containterTK addSubview:iconTK];
    [_User setLeftView:containterTK];
    [_User setLeftViewMode:UITextFieldViewModeAlways];
    
    UIView * containterP = [[UIView alloc]init];
    [containterP setFrame:CGRectMake(0.0f, 0.0f, 45.0f, 23.0f)];
    [containterP setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *iconP= [[UIImageView alloc] init];
    [iconP setImage:[UIImage imageNamed:@"Pass60.png"]];
    [iconP setFrame:CGRectMake(10.0f, 0.0f, 23.0f, 23.0f)];
    [containterP addSubview:iconP];
    [_Pass setLeftView:containterP];
    [_Pass setLeftViewMode:UITextFieldViewModeAlways];
    
    CGRect frame = CGRectMake(40, 327.0, 0, 0);
    switchLogin = [[UISwitch alloc] initWithFrame:frame];
    switchLogin.transform = CGAffineTransformMakeScale(0.80, 0.75);
    switchLogin.onTintColor = [UIColor colorWithRed:0.992 green:0.729 blue:0.157 alpha:1.00];
    [switchLogin addTarget:self action:@selector(SwitchClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchLogin];
    [switchLogin setOn:NO];

    [switchLogin setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_lbl_duytri setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:switchLogin
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_lbl_duytri
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:-25]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:switchLogin
                                                          attribute:NSLayoutAttributeBaseline
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_lbl_duytri
                                                          attribute:NSLayoutAttributeBaseline
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:switchLogin
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_lbl_duytri
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];
    if (IS_IPHONE6PLUS){[ _img_login setImage:[UIImage imageNamed:@"1242x2208"]]; NSLog(@"%@",_img_login.image);}
    else if(IS_IPHONE6){ [_img_login setImage:[UIImage imageNamed:@"750x1334"]];NSLog(@"%@",_img_login.image);}
    else if(IS_IPHONE5S){[_img_login setImage:[UIImage imageNamed:@"640x1136"]];NSLog(@"%@",_img_login.image);}
    else if(IS_IPHONE4){[_img_login setImage:[UIImage imageNamed:@"640x960"]];NSLog(@"%@",_img_login.image);}
}
/////////////////////dont langspace device///////////////////
-(BOOL)shouldAutorotate {
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
/////////////////////dont langspace device///////////////////

- (IBAction)SwitchClick:(UIButton *)sender {
    NSString *value = @"ON";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if(!switchLogin.on){
        value = @"OFF";
        [defaults setObject:value forKey:@"stateOfSwitch"];
    }
    else {
        [defaults setObject:value forKey:@"stateOfSwitch"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString * _value = [def stringForKey:@"stateOfSwitch"];
    if([_value compare:@"OFF"]== NSOrderedSame){
        switchLogin.on = NO;
    }
    else {
        switchLogin.on = YES;
    }
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)keyboardWillAppear {
    // Move current view up / down with Animation
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewUp:NO];
    }
}
-(void)keyboardWillDisappear {
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewUp:NO];
    }
}
-(void)moveViewUp:(BOOL)bMovedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
   // NSInteger number = 260;
    CGRect rect = self.view.frame;
    if (bMovedUp) {
        // 1. move the origin of view up so that the text field will come above the keyboard
        if(IS_IPHONE5S ){
        rect.origin.y -= 277;
            rect.size.height += 100;
        NSLog(@"frame %@",NSStringFromCGRect(rect));
   
        }
        if(IS_IPHONE4 ){
            rect.origin.y -= 225;
            rect.size.height += 60;
            NSLog(@"frame %@",NSStringFromCGRect(rect));
            
        }
        // 2. increase the height of the view to cover up the area behind the keyboard
        if(IS_IPHONE6){
        rect.origin.y -= 80;
        rect.size.height -= 40;
        NSLog(@"frame1 %@",NSStringFromCGRect(rect));
        }
        if(IS_IPHONE6PLUS){
            rect.origin.y -= 80;
            
        }

        
    } else {
        if(IS_IPHONE6){
            rect.origin.y += 80;
             rect.size.height += 40;
        }
        if(IS_IPHONE6PLUS){
            rect.origin.y += 80;
        }
        if(IS_IPHONE5S){
            rect.origin.y += 277;
          rect.size.height -= 100;
            
        }
        if(IS_IPHONE4){
            rect.origin.y += 225;
            rect.size.height -= 60;
            
        }
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   
        [_Pass resignFirstResponder];
  
        [self moveViewUp:NO];
  }

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_Pass]&&[textField isEqual:_User]){
        // txtEmail is UITextField control for email address
        
        if  (self.view.frame.origin.y >= 0)
        {
            [self moveViewUp:YES];
        }
    }
    if(_Pass.editing == TRUE ){
        
        _Pass.placeholder = nil;
        
    }
    if(_Pass.editing == FALSE){
        
        _Pass.placeholder = @"Mật khẩu";
    }
    if(_User.editing == TRUE ){
        _User.placeholder = nil;
    }
   if(_User.editing == FALSE){
        
        _User.placeholder = @"Tài khoản";
    }
  
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { // ẩn bàn phím khi sửa xong
    [_User endEditing:YES];
    [_Pass endEditing:YES];
    [_User resignFirstResponder];
    [_Pass resignFirstResponder];
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    if(_User.editing == FALSE){
        
        _User.placeholder = @"Tài khoản";
    }
    if(_Pass.editing == FALSE){
        
        _Pass.placeholder = @"Mật khẩu";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{ //event for return key done or or of keyboard
    if( _User.editing == TRUE){

        [_User resignFirstResponder];
        [self moveViewUp:YES];
        [_Pass becomeFirstResponder];
        
    }else if(_Pass.editing == TRUE){
        [self btn_dangnhap:0];
    }
    return YES;
    
}
-(void)doSomeFunkyDtuff{
    float progress= 0.0;
    while (progress < 1.0) {
        progress+=0.02;
        hud.progress = progress;
        usleep(50000);
    }
}
- (IBAction)btn_dangnhap:(id)sender {
    if ([[_User text] isEqualToString:@""] || [[_Pass text]isEqualToString:@""]) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Yêu cầu tài khoản và mật khẩu, vui lòng kiểm tra lại !" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", "OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSLog(@"ÁDADSASD");
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
        //check internet
        Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.google.com"];
        NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
        if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
            /// Create an alert if connection doesn't work,no internet connection
            UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Không có kết nối Internet.Hãy bật WIFI hoặc 3G để ứng dụng hoạt động!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", "OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        
    }
        else {
        //xoá cookie
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *post =[[NSString alloc] initWithFormat:@"%@:%@",_User.text,_Pass.text];
            if(switchLogin.on == YES)
            {
                //save username
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:_User.text forKey:@"textField1Text"];
                //save password
                [defaults setObject:_Pass.text forKey:@"textField2Text"];
                [defaults synchronize];
                
            } else
            {
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:@"" forKey:@"textField1Text"];
                [defaults setObject:@"" forKey:@"textField2Text"];
                [defaults synchronize];
            }
            //request Post and take response
        NSURL *url=[NSURL URLWithString:@"https://cms.sungroup.com.vn/restws/session/token"];
        NSData *authData = [post dataUsingEncoding:NSASCIIStringEncoding];
        // NSData *authData = [post dataUsingEncoding:NSUTF8StringEncoding];
        //NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSString *basic = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        NSLog(@"pos %@",basic);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //reponse json
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:basic forHTTPHeaderField:@"Authorization"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:authData];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
            
            
        ////

        if (!urlData){
            Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.google.com"];
            NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
            if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
            UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Không có kết nối Internet.Hãy bật WIFI hoặc 3G để ứng dụng hoạt động!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", "OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
            //NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            //NSMutableDictionary  * json = [NSJSONSerialization JSONObjectWithData:urlData options: NSJSONReadingMutableContainers error: &error];
            //NSLog(@"ádasd %@",json);
            NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSMutableString *str_01 = [NSMutableString stringWithString:responseData];
            if(str_01 == NULL){
                UIAlertController *aleart = [UIAlertController alertControllerWithTitle:@"Thông báo !" message:@"Tài khoản đăng nhập không chính xác, vui lòng kiểm tra lại !" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
            [aleart addAction:ok];
            [self presentViewController:aleart animated:YES completion:nil];
            }
            // lấy cookie về
            NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                      [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            for (NSHTTPCookie * cookie in cookies)
            {
                NSLog(@"ket qua: %@ = %@",cookie.name,cookie.value);
                strSessName = cookie.name;
                strSessVal = cookie.value;
            }
            //truyền dữ liệu
            NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
            [defaults1 setObject:strSessVal forKey:@"valuecc"];
            [defaults1 setObject:strSessName forKey:@"namecc"];
            [defaults1 synchronize];
            
            if(strSessName == nil || strSessVal == nil){
                UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Tài khoản đăng nhập không chính xác, vui lòng kiểm tra lại !" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", "OK acction") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            hud1.labelText = @"Đang tải dữ liệu...";
            hud1.dimBackground = YES;
            [self performSegueWithIdentifier:@"success" sender:self];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            [hud1 hide:YES];
        }
    }

        @end

