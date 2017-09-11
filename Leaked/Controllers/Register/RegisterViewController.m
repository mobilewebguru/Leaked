//
//  RegisterViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <QuartzCore/QuartzCore.h>

#import "RegisterViewController.h"

#import "APIClient.h"
#import "Account.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// RegisterViewController Class;
@interface RegisterViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// Properties;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation RegisterViewController

// Functions;
#pragma mark - RegisterViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];

    // Avatar;
    btnForAvatar.layer.borderWidth = 1.0f;
    btnForAvatar.layer.borderColor = [UIColor colorWithRed:155.0f / 255.0f green:155.0f / 255.0f blue:155.0f / 255.0f alpha:1.0f].CGColor;
    btnForAvatar.layer.cornerRadius = btnForAvatar.bounds.size.width / 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Status;
    imgForName.hidden = YES;
    imgForUsername.hidden = YES;
    imgForEmail.hidden = YES;
    imgForConfirmEmail.hidden = YES;
    imgForPassword.hidden = YES;
    imgForConfirmPassword.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Scroll;
    viewForScroll.contentSize = viewForContent.frame.size;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Navigation Bar;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Navigation Bar;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            
            // Present;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
            break;
        }
            
        case 1:
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            
            // Present;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)pickerController didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Set;
    self.avatar = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // UI;
    [btnForAvatar setImage:self.avatar forState:UIControlStateNormal];
    
    // Dismiss;
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerController
{
    // Dismiss;
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtForName) {
        imgForName.hidden = txtForName.text.length == 0;
        imgForName.highlighted = txtForName.text.length > 1;
        
        [txtForUsername becomeFirstResponder];
    } else if (textField == txtForUsername) {
        imgForUsername.hidden = txtForUsername.text.length == 0;
        imgForUsername.highlighted = txtForUsername.text.length > 1;
        
        [txtForEmail becomeFirstResponder];
    } else if (textField == txtForEmail) {
        imgForEmail.hidden = txtForEmail.text.length == 0;
        imgForEmail.highlighted = [self isEmailAddress:txtForEmail.text];
        
        [txtForConfirmEmail becomeFirstResponder];
    } else if (textField == txtForConfirmEmail) {
        imgForConfirmEmail.hidden = txtForConfirmEmail.text.length == 0;
        imgForConfirmEmail.highlighted = [self isEmailAddress:txtForConfirmEmail.text] && [txtForEmail.text isEqualToString:txtForConfirmEmail.text];
        
        [txtForPassword becomeFirstResponder];
    } else if (textField == txtForPassword) {
        imgForPassword.hidden = txtForPassword.text.length == 0;
        imgForPassword.highlighted = txtForPassword.text.length > 6;
        
        [txtForConfirmPassword becomeFirstResponder];
    } else if (textField == txtForConfirmPassword) {
        imgForConfirmPassword.hidden = txtForConfirmPassword.text.length == 0;
        imgForConfirmPassword.highlighted = txtForConfirmPassword.text.length > 6 && [txtForPassword.text isEqualToString:txtForConfirmPassword.text];

        [txtForConfirmPassword resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Notification
- (void)willShowKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = viewForScroll.frame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.size.height = self.view.bounds.size.height - keyboardFrame.size.height;
    
    // Animation;
    [UIView animateWithDuration:duration animations:^{
        viewForScroll.frame = frame;
    }];
}

- (void)willHideKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = viewForContent.frame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.size.height = self.view.bounds.size.height;
        
    // Animation;
    [UIView animateWithDuration:duration animations:^{
        viewForScroll.frame = frame;
    }];
}

#pragma mark - Alert Tips
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

#pragma mark - Check
- (BOOL)checkBlankField
{
    NSArray *fields = [NSArray arrayWithObjects:txtForName, txtForUsername, txtForEmail, txtForConfirmEmail, txtForPassword, txtForConfirmEmail, nil];
    
    for (NSInteger i = 0; i < [fields count]; i++) {
        UITextField *field = fields[i];
        
        if ([field.text isEqualToString:@""]) {
            [self showAlertWithTitle:nil message:@"Please fill in all the details."];
            return NO;
        }
    }
    
    return YES;
}

- (void)checkUsername
{
    
}

- (BOOL)isEmailAddress:(NSString *)email
{
    BOOL filter = YES;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)checkEmail
{
    BOOL filter = YES;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:txtForEmail.text]) {
        [self showAlertWithTitle:nil message:@"Input a valid Email address."];
        return NO;
    }
    
    if (![txtForEmail.text isEqualToString:txtForConfirmEmail.text]) {
        [self showAlertWithTitle:nil message:@"Input a valid Email address."];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkPassword
{
    if ([txtForPassword.text length] < 6) {
        [self showAlertWithTitle:nil message:@"Passwords must be at least 6 characters."];
        return NO;
    }
    
    if (![txtForPassword.text isEqualToString:txtForConfirmPassword.text]) {
        [self showAlertWithTitle:nil message:@"Passwords not match."];
        return NO;
    }
    
    return YES;
}

- (void)resignResponders
{
    if ([txtForName isFirstResponder]) {
        [txtForName resignFirstResponder];
    } else if ([txtForUsername isFirstResponder]) {
        [txtForUsername resignFirstResponder];
    } else if ([txtForEmail isFirstResponder]) {
        [txtForEmail resignFirstResponder];
    } else if ([txtForConfirmEmail isFirstResponder]) {
        [txtForConfirmEmail resignFirstResponder];
    } else if ([txtForPassword isFirstResponder]) {
        [txtForPassword resignFirstResponder];
    } else if ([txtForConfirmPassword isFirstResponder]) {
        [txtForConfirmPassword resignFirstResponder];
    }
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnAvatar:(id)sender
{
    [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose Existing Photo", nil] showInView:self.view];
}

- (IBAction)onBtnRegister:(id)sender
{
    // Check;
    if (![self checkBlankField]) {
        return;
    }

    if (![self checkEmail]) {
        return;
    }
    
    if (![self checkPassword]) {
        return;
    }
    
    // Resign;
    [self resignResponders];

    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Register;
    [APIClient registerWithAvatar:self.avatar name:txtForName.text username:txtForUsername.text email:txtForEmail.text password:txtForPassword.text completion:^(Account *account, BOOL successed) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([account isAuthenticated]) {
            // Dismiss;
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                // Notification;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogin" object:nil];
            }];
        }
    }];
}

@end
