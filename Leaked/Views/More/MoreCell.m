//
//  MoreCell.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "MoreCell.h"

// --- Defines ---;
// MoreCell Class;
@implementation MoreCell

// Functions;
#pragma mark - MoreCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)startAnimating
{
    [activityIndicatorView startAnimating];
}

- (void)stopAnimating
{
    [activityIndicatorView stopAnimating];
}

@end
