//
//  ConnectCell.h
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
// ConnectCellDelegate Protocol;
@protocol ConnectCellDelegate <NSObject>
@optional

- (void)didUser:(User *)user;
- (void)didFollow:(User *)user;

@end

// ConnectCell Class;
@interface ConnectCell : UITableViewCell
{
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UILabel *lblForName;
    IBOutlet UILabel *lblForUsername;
    IBOutlet UILabel *lblForPosts;
    IBOutlet UILabel *lblForFollowers;
    IBOutlet UILabel *lblForFollowings;
    IBOutlet UIButton *btnForFollow;
    IBOutlet UIActivityIndicatorView *indicatorView;
}

// Properties;
@property (nonatomic, weak) id <ConnectCellDelegate> delegate;
@property (nonatomic, weak) User *user;

@end
