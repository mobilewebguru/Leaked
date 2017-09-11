//
//  FeedViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// FeedViewController Class;
@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *tblForFeed;
    IBOutlet UIView *viewForBanner;    
    IBOutlet UIView *viewForReply;
    IBOutlet UITextView *txtForComment;
}

@end
