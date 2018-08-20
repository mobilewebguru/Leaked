//
//  PickerView.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class PickerView;

// --- Defines ---;
// PickerViewDataSource Protocol;
@protocol PickerViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPickerView:(PickerView *)pickerView;
- (UIImage *)pickerView:(PickerView *)pickerView titleForItem:(NSInteger)item;

@end

// PickerViewDelegate Protocol;
@protocol PickerViewDelegate <NSObject>

- (void)pickerView:(PickerView *)pickerView didSelectItem:(NSInteger)item;

@optional

- (void)pickerViewWillBeginChangingItem:(PickerView *)pickerView;

@end

// PickerView Class;
@interface PickerView : UIView

// Properties;
@property (nonatomic, unsafe_unretained) IBOutlet id<PickerViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) IBOutlet id<PickerViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedItem;

// Functions;
- (void)reloadData;
- (void)setSelectedItem:(NSUInteger)selectedItem animated:(BOOL)animated;

@end
