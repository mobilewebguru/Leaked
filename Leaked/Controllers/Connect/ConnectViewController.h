//
//  ConnectViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// ConnectViewController Class;
@interface ConnectViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UITextField *txtForSearch;
    IBOutlet UITableView *tblForConnect;
    IBOutlet UIView *viewForBanner;
}

@end
