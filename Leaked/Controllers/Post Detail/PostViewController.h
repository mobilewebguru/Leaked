//
//  PostViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class Post;
@class PickerView;

// --- Defines ---;
// PostViewController Class;
@interface PostViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *tblForPost;
    IBOutlet UIView *viewForBanner;
    
    IBOutlet UIView *viewForReply;
    IBOutlet UITextView *txtForComment;    
}

// Properties;
@property (nonatomic, strong) Post *post;

@end
