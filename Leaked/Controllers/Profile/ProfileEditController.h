//
//  ProfileEditController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// ProfileEditController Class;
@interface ProfileEditController : UIViewController
{
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIView *viewForContent;
    IBOutlet UIButton *btnForAvatar;
    IBOutlet UITextField *txtForName;
    IBOutlet UIImageView *imgForName;
    IBOutlet UITextField *txtForUsername;
    IBOutlet UIImageView *imgForUsername;
    IBOutlet UITextField *txtForEmail;
    IBOutlet UIImageView *imgForEmail;
    IBOutlet UITextField *txtForConfirmEmail;
    IBOutlet UIImageView *imgForConfirmEmail;
    IBOutlet UITextField *txtForPassword;
    IBOutlet UIImageView *imgForPassword;
    IBOutlet UITextField *txtForConfirmPassword;
    IBOutlet UIImageView *imgForConfirmPassword;
    
    IBOutlet UIView *viewForBanner;
    
    IBOutlet UIView *viewForBiography;
    IBOutlet UITextView *txtForBiography;
}

@end
