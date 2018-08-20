//
//  FeedCell.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class Post;
@class PickerView;

// --- Defines ---;
// FeedCellDelegate Protocol;
@protocol FeedCellDelegate <NSObject>
@optional

- (void)didDelete;
- (void)didReply:(Post *)post withItem:(NSInteger)item;
- (void)didReport:(Post *)post;

@end

// FeedCell Class;
@interface FeedCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet UIButton *btnForDelete;
    IBOutlet UILabel *lblForComment;
    IBOutlet UICollectionView *viewForIcon;
    IBOutlet PickerView *viewForPicker;
    IBOutlet UILabel *lblForTime;
}

// Properties;
@property (nonatomic, weak) id<FeedCellDelegate> delegate;
@property (nonatomic, weak) Post *post;

// Functions;
+ (CGFloat)heightForPost:(Post *)post;

@end
