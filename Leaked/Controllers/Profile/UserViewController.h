//
//  UserViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class User;

// --- Defines ---;
// UserViewController Class;
@interface UserViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UILabel *lblForPosts;
    IBOutlet UILabel *lblForFollowers;
    IBOutlet UILabel *lblForFollowings;
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UILabel *lblForName;
    IBOutlet UILabel *lblForUsername;
    IBOutlet UIButton *btnForFollow;
    IBOutlet UILabel *lblForPeoples;
    IBOutlet UITextView *txtForBiography;
}

// Properties;
@property (nonatomic, weak) User *user;

@end
