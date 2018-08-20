//
//  NavigationController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "NavigationController.h"

#import "UIViewController+ECSlidingViewController.h"

// --- Defines ---;
// SlideViewController Class;
@interface NavigationController ()

@end

@implementation NavigationController

// Functions;
#pragma mark - NavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowRadius = 1.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//  [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
