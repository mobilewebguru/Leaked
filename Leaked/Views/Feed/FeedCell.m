//
//  FeedCell.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "FeedCell.h"
#import "IconCell.h"

#import "Account.h"
#import "Post.h"
#import "Mark.h"

#import "Helper.h"

#import "PickerView.h"

// --- Defines ---;
// FeedCell Class;
@interface FeedCell () <PickerViewDataSource, PickerViewDelegate>

@end

@implementation FeedCell

// Functions;
+ (CGFloat)heightForPost:(Post *)post
{    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [post.comment boundingRectWithSize:CGSizeMake(275.0f, 999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat height = rect.size.height;
    
    return height + 130.0f;
}

#pragma mark - FeedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - UICollectionCellDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"IconCell";
    IconCell *cell = [viewForIcon dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    // Set;
    switch (indexPath.row) {
        case 0:
            [cell setIcon:[UIImage imageNamed:@"other_heart"]];
            [cell setCount:self.post.mark.hearts];
            break;
            
        case 1:
            [cell setIcon:[UIImage imageNamed:@"other_heart_eyes"]];
            [cell setCount:self.post.mark.heartEyes];
            break;
            
        case 2:
            [cell setIcon:[UIImage imageNamed:@"other_angry_face"]];
            [cell setCount:self.post.mark.angryFaces];
            break;
            
        case 3:
            [cell setIcon:[UIImage imageNamed:@"other_question_mark"]];
            [cell setCount:self.post.mark.questionMarks];
            break;
            
        case 4:
            [cell setIcon:[UIImage imageNamed:@"other_wtf"]];
            [cell setCount:self.post.mark.wtfs];
            break;
            
        case 5:
            [cell setIcon:[UIImage imageNamed:@"other_thumb_down"]];
            [cell setCount:self.post.mark.thumbDowns];
            break;
         
        case 6:
            [cell setIcon:[UIImage imageNamed:@"other_middle_finger"]];
            [cell setCount:self.post.mark.middleFingers];
            break;
            
        case 7:
            [cell setIcon:[UIImage imageNamed:@"other_repost"]];
            [cell setCount:self.post.mark.reposts];
            break;
            
        case 8:
            [cell setIcon:[UIImage imageNamed:@"other_save"]];
            [cell setCount:self.post.mark.saves];
            break;
         
        case 9:
            [cell setIcon:[UIImage imageNamed:@"other_reply"]];
            [cell setCount:self.post.mark.replies];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfItemsInPickerView:(PickerView *)pickerView
{
    return 10;
}

- (UIImage *)pickerView:(PickerView *)pickerView titleForItem:(NSInteger)item
{
    // Set;
    switch (item) {
        case 0:
            return [UIImage imageNamed:@"other_heart"];
            
        case 1:
            return [UIImage imageNamed:@"other_heart_eyes"];
            
        case 2:
            return [UIImage imageNamed:@"other_angry_face"];
            
        case 3:
            return [UIImage imageNamed:@"other_question_mark"];
            
        case 4:
            return [UIImage imageNamed:@"other_wtf"];
            
        case 5:
            return [UIImage imageNamed:@"other_thumb_down"];
            
        case 6:
            return [UIImage imageNamed:@"other_middle_finger"];
            
        case 7:
            return [UIImage imageNamed:@"other_repost"];
            
        case 8:
            return [UIImage imageNamed:@"other_save"];
            
        case 9:
            return [UIImage imageNamed:@"other_reply"];
            
        default:
            break;
    }

    return nil;
}

- (void)pickerView:(PickerView *)pickerView didSelectItem:(NSInteger)item
{
    
}

- (void)setPost:(Post *)post
{
    // Set;
    _post = post;
    
    // UI;
    btnForDelete.hidden = ![[Account me].userID isEqualToString:_post.userID];
    lblForComment.text = _post.comment;
    lblForTime.text = [Helper time:_post.createAt];
    
    [viewForIcon reloadData];
    [viewForPicker reloadData];
}

#pragma mark - Events
- (IBAction)onBtnDelete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didDelete)]) {
        [self.delegate didDelete];
    }
}

- (IBAction)onBtnReply:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didReply: withItem:)]) {
        [self.delegate didReply:self.post withItem:viewForPicker.selectedItem];
    }
}

- (IBAction)onBtnReport:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didReport:)]) {
        [self.delegate didReport:self.post];
    }
}

@end
