//
//  LoginViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// LoginViewController Class;
@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIView *viewForContent;
    IBOutlet UITextField *txtForUsername;
    IBOutlet UIImageView *imgForUsername;
    IBOutlet UITextField *txtForPassword;
    IBOutlet UIImageView *imgForPassword;
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
