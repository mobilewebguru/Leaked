//
//  ConnectCell.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "ConnectCell.h"

#import "User.h"

#import "UIImageView+WebCache.h"

// --- Defines ---;
// ConnectCell Class;
@implementation ConnectCell

// Functions;
#pragma mark - ConnectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Avatar;
    // Avatar;
    imgForAvatar.layer.borderWidth = 1.0f;
    imgForAvatar.layer.borderColor = [UIColor colorWithRed:155.0f / 255.0f green:155.0f / 255.0f blue:155.0f / 255.0f alpha:1.0f].CGColor;
    imgForAvatar.layer.cornerRadius = imgForAvatar.bounds.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setUser:(User *)user
{
    // Set;
    _user = user;
    
    // UI;
    [imgForAvatar sd_setImageWithURL:[NSURL URLWithString:_user.avatar] placeholderImage:nil];
    lblForName.text = _user.name;
    lblForUsername.text = _user.username;
    lblForPosts.text = [[NSNumber numberWithInteger:_user.posts] stringValue];
    lblForFollowers.text = [[NSNumber numberWithInteger:_user.followers] stringValue];
    lblForFollowings.text = [[NSNumber numberWithInteger:_user.followings] stringValue];
    
    if ([[User me].userID isEqualToString:_user.userID]) {
        btnForFollow.hidden = YES;
        [indicatorView stopAnimating];
    } else {
        switch (_user.following) {
            case 0:
                btnForFollow.hidden = NO;
                btnForFollow.selected = NO;
                [indicatorView stopAnimating];
                break;
                
            case 1:
                btnForFollow.hidden = NO;
                btnForFollow.selected = YES;
                [indicatorView stopAnimating];
                break;
                
            case 2 :
                btnForFollow.hidden = YES;
                btnForFollow.selected = NO;
                [indicatorView startAnimating];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Events
- (IBAction)onBtnFollow:(id)sender
{
    // UI;
    btnForFollow.hidden = YES;
    [indicatorView startAnimating];
    
    // Follow;
    if ([self.delegate respondsToSelector:@selector(didFollow:)]) {
        [self.delegate performSelector:@selector(didFollow:) withObject:self.user];
    }
}

@end
