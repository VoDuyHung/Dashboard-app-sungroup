//
//  LoginViewController.h
//  DashBoardSG
//
//  Created by Võ Duy Hùng  on 5/11/16.
//  Copyright © 2016 Võ Duy Hùng . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    UISwitch * switchLogin;
}
@property (weak, nonatomic) IBOutlet UITextField *User;
@property (weak, nonatomic) IBOutlet UIImageView *img_login;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UITextField *Pass;
- (IBAction)btn_dangnhap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_duytri;

@end
