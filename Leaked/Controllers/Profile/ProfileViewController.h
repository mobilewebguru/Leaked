//
//  ProfileViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// ProfileViewController Class;
@interface ProfileViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
    IBOutlet UILabel *lblForPosts;
    IBOutlet UILabel *lblForFollowers;
    IBOutlet UILabel *lblForFollowings;
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UILabel *lblForName;
    IBOutlet UILabel *lblForUsername;
    IBOutlet UILabel *lblForPeoples;
    IBOutlet UITextView *txtForBiography;
}

@end
