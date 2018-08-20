//
//  OtherViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "OtherViewController.h"
#import "OtherListController.h"
#import "CreatePostController.h"

#import "IconCell.h"

#import "APIClient.h"
#import "Account.h"
#import "Mark.h"

#import "UIViewController+ECSlidingViewController.h"

// --- Defines ---;
// OtherViewController Class;
@interface OtherViewController ()

// Properties;
@property (nonatomic, strong) Mark *mark;

@end

@implementation OtherViewController

// Functions;
#pragma mark - OtherViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load;
    [self loadMarks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"IconCell";
    IconCell *cell = [viewForOther dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Set;
    switch (indexPath.row) {
        case 0:
            [cell setIcon:[UIImage imageNamed:@"other_heart"]];
            [cell setCount:self.mark.hearts];
            break;
            
        case 1:
            [cell setIcon:[UIImage imageNamed:@"other_heart_eyes"]];
            [cell setCount:self.mark.heartEyes];
            break;
            
        case 2:
            [cell setIcon:[UIImage imageNamed:@"other_angry_face"]];
            [cell setCount:self.mark.angryFaces];
            break;
            
        case 3:
            [cell setIcon:[UIImage imageNamed:@"other_question_mark"]];
            [cell setCount:self.mark.questionMarks];
            break;
            
        case 4:
            [cell setIcon:[UIImage imageNamed:@"other_wtf"]];
            [cell setCount:self.mark.wtfs];
            break;
            
        case 5:
            [cell setIcon:[UIImage imageNamed:@"other_thumb_down"]];
            [cell setCount:self.mark.thumbDowns];
            break;
            
        case 6:
            [cell setIcon:[UIImage imageNamed:@"other_middle_finger"]];
            [cell setCount:self.mark.middleFingers];
            break;
            
        case 7:
            [cell setIcon:[UIImage imageNamed:@"other_repost"]];
            [cell setCount:self.mark.reposts];
            break;
            
        case 8:
            [cell setIcon:[UIImage imageNamed:@"other_save"]];
            [cell setCount:self.mark.saves];
            break;
            
        case 9:
            [cell setIcon:[UIImage imageNamed:@"other_reply"]];
            [cell setCount:self.mark.replies];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set;
    switch (indexPath.row) {
        case 0:
            if (self.mark.hearts) {
                [self showMarkedPosts:@"hearts"];
            }
            break;
            
        case 1:
            if (self.mark.heartEyes) {
                [self showMarkedPosts:@"heart_eyes"];
            }
            break;
            
        case 2:
            if (self.mark.angryFaces) {
                [self showMarkedPosts:@"angry_faces"];
            }
            break;
            
        case 3:
            if (self.mark.questionMarks) {
                [self showMarkedPosts:@"question_marks"];
            }
            break;
            
        case 4:
            if (self.mark.wtfs) {
                [self showMarkedPosts:@"wtfs"];
            }
            break;
            
        case 5:
            if (self.mark.thumbDowns) {
                [self showMarkedPosts:@"thumb_downs"];
            }
            break;
            
        case 6:
            if (self.mark.middleFingers) {
                [self showMarkedPosts:@"middle_fingers"];
            }
            break;
            
        case 7:
            if (self.mark.reposts) {
                [self showMarkedPosts:@"reposts"];
            }
            break;
            
        case 8:
            if (self.mark.saves) {
                [self showMarkedPosts:@"saves"];
            }
            break;
            
        case 9:
            if (self.mark.replies) {
                [self showMarkedPosts:@"replies"];
            }
            break;
            
        default:
            break;
    }
}

- (void)showMarkedPosts:(NSString *)mark
{
    OtherListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherListController"];
    viewController.mark = mark;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Load
- (void)loadMarks
{
    [APIClient getAccountMarks:^(Mark *mark) {
        // Set;
        self.mark = mark;
        
        // Reload;
        [viewForOther reloadData];
    }];
}

#pragma mark - Events
- (IBAction)onBtnMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)onBtnPost:(id)sender
{
    CreatePostController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
