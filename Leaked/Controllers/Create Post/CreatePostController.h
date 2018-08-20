//
//  CreatePostController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class Post;

// --- Defines ---;
// CreatePostController Class;
@interface CreatePostController : UIViewController <UITextViewDelegate>
{
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UILabel *lblForName;
    IBOutlet UILabel *lblForUsername;
    IBOutlet UITextView *txtForComment;
    IBOutlet UIView *viewForBanner;
}

// Properties;
@property (nonatomic, strong) Post *post;

@end
