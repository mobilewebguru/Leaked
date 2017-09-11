//
//  MoreCell.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// MoreCell Class;
@interface MoreCell : UITableViewCell
{
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
}

// Functions;
- (void)startAnimating;
- (void)stopAnimating;

@end
