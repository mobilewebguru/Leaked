//
//  WebViewController.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// WebViewController Class;
@interface WebViewController : UIViewController
{
    IBOutlet UIWebView *viewWeb;
}

// Properties;
@property (nonatomic, strong) NSString *titleOfController;
@property (nonatomic, strong) NSString *url;

@end
