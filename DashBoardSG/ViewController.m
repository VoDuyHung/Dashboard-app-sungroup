//
//  ViewController.m
//  DashBoardSG
//
//  Created by Võ Duy Hùng  on 5/11/16.
//  Copyright © 2016 Võ Duy Hùng . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *se;
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (weak, nonatomic) IBOutlet UITextField *se1;
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.width) ==320.0f && ([[UIScreen mainScreen] bounds].size.height) ==480.0f)
#define kOFFSET_FOR_KEYBOARD 80.0

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
   if(IS_IPHONE4){
    CGPoint scrollPoint = CGPointMake(0, 100);
     if( self.se.editing == TRUE){
         NSLog(@"add1");
    [self.sc setContentOffset:scrollPoint animated:YES];
    }
    if(self.se1.editing == TRUE){
        NSLog(@"add");
        [self.sc setContentOffset:scrollPoint animated:YES];
    }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
   if(IS_IPHONE4){
    NSLog(@"adad");
    [self.sc setContentOffset:CGPointZero animated:YES];
}
     [self.se resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { // ẩn bàn phím khi sửa xong
    [self.se endEditing:YES];
    [self.se1 endEditing:YES];
    if(self.se == FALSE){
        
        self.se.placeholder = @"Mật khẩu";
    }
}

@end
