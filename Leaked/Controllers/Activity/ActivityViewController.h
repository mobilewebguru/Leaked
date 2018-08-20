//
//  ActivityViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// ActivityViewController Class;
@interface ActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tblForActivity;
    IBOutlet UIView *viewForBanner;
}

@end
