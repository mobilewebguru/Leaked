//
//  MenuTableController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "MenuTableController.h"

// --- Defines ---;
// MenuTableController Class;
@interface MenuTableController ()

@end

@implementation MenuTableController

// Functions;
#pragma mark - MenuTableController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(didFeed)]) {
                [self.delegate performSelector:@selector(didFeed) withObject:nil];
            }
            break;
            
        case 1:
            if ([self.delegate respondsToSelector:@selector(didActivity)]) {
                [self.delegate performSelector:@selector(didActivity) withObject:nil];
            }
            break;
            
        case 2:
            if ([self.delegate respondsToSelector:@selector(didProfile)]) {
                [self.delegate performSelector:@selector(didProfile) withObject:nil];
            }
            break;
            
        case 3:
            if ([self.delegate respondsToSelector:@selector(didConnect)]) {
                [self.delegate performSelector:@selector(didConnect) withObject:nil];
            }
            break;
            
        case 4:
            if ([self.delegate respondsToSelector:@selector(didSaved)]) {
                [self.delegate performSelector:@selector(didSaved) withObject:nil];
            }
            break;
            
        case 5:
            if ([self.delegate respondsToSelector:@selector(didOther)]) {
                [self.delegate performSelector:@selector(didOther) withObject:nil];
            }
            break;
            
        case 6:
            if ([self.delegate respondsToSelector:@selector(didSettings)]) {
                [self.delegate performSelector:@selector(didSettings) withObject:nil];
            }
            break;
            
        default:
            break;
    }
}

@end
