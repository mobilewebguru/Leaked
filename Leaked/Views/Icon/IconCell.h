//
//  IconCell.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// IconCell Class;
@interface IconCell : UICollectionViewCell
{
    IBOutlet UIView *viewForCount;
    IBOutlet UILabel *lblForCount;
    IBOutlet UIImageView *imgForIcon;
}

// Functions;
- (void)setCount:(NSInteger)count;
- (void)setIcon:(UIImage *)icon;

@end
