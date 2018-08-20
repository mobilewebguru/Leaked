//
//  OtherListController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// OtherListController Class;
@interface OtherListController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tblForOther;
    IBOutlet UIView *viewForBanner;
}

// Properties;
@property (nonatomic, strong) NSString *mark;

@end
