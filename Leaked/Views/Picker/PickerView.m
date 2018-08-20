//
//  PickerView.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "PickerView.h"

// --- Defines ---;
// PickerView Class;
@interface PickerView () <UIScrollViewDelegate>
{
    UIImageView *imgForBackground;
    UIImageView *imgForBackgroundOverlay;
    UIImageView *imgForShadow;
    UIView *viewForContent;
    UIScrollView *viewForScroll;
    
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
    NSUInteger itemCount;
}

@end

@implementation PickerView

#pragma mark - PickerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        return viewForScroll;
    }
    
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tileViews];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(pickerViewWillBeginChangingItem:)]) {
        [self.delegate pickerViewWillBeginChangingItem:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
/*  if (velocity.x > kCPPickerDecelerationThreshold && self.allowSlowDeceleration) {
        contentView.pagingEnabled = NO;
    } */
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self determineCurrentItem];
    
    if (!viewForScroll.pagingEnabled) {
        [self scrollToIndex:self.selectedItem animated:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    viewForScroll.pagingEnabled = YES;
}

#pragma mark -
- (void)setupView
{
    _selectedItem = 0;
    itemCount = 0;
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];

    // Background;
    imgForBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 95)];
    imgForBackground.image = [UIImage imageNamed:@"picker_background"];
    [self addSubview:imgForBackground];
    
    // Background Overlay;
    imgForBackgroundOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(1, -3, 37, 101)];
    imgForBackgroundOverlay.image = [UIImage imageNamed:@"picker_background_overlay"];
    [self addSubview:imgForBackgroundOverlay];

    viewForContent = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 39, 93)];
    viewForContent.backgroundColor = [UIColor clearColor];
    viewForContent.clipsToBounds = YES;
    [self addSubview:viewForContent];
    
    // Content View;
    viewForScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 28, 39, 37)];
    viewForScroll.delegate = self;
    viewForScroll.clipsToBounds = NO;
    viewForScroll.backgroundColor = [UIColor clearColor];
    viewForScroll.showsHorizontalScrollIndicator = NO;
    viewForScroll.showsVerticalScrollIndicator = NO;
    viewForScroll.pagingEnabled = YES;
    viewForScroll.scrollsToTop = NO;
    [viewForContent addSubview:viewForScroll];

    // Shadow;
    imgForShadow = [[UIImageView alloc] initWithFrame:CGRectMake(2, 1, 35, 93)];
    imgForShadow.image = [UIImage imageNamed:@"picker_shadow"];
    [self addSubview:imgForShadow];

    // Reload;
    [self reloadData];
}

- (void)tileViews
{
    // Calculate which pages are visible;
    CGRect visibleBounds = viewForScroll.bounds;
    NSInteger currentViewIndex = floorf(viewForScroll.contentOffset.y / viewForScroll.frame.size.height);
    NSInteger firstNeededViewIndex = currentViewIndex - 2;
    NSInteger lastNeededViewIndex  = currentViewIndex + 2;
    
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, itemCount - 1);
	
    // Recycle no-longer-visible pages;
    for (UIView *visibleView in visibleViews) {
        int viewIndex = visibleView.frame.origin.y / visibleBounds.size.height - 2;
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex) {
            [recycledViews addObject:visibleView];
            [visibleView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // Add missing pages;
	for (NSInteger index = firstNeededViewIndex; index <= lastNeededViewIndex; index ++) {
        if (![self isDisplayingViewForIndex:index]) {
            UIView *recycledView = [self dequeueRecycledView];
            
            if (!recycledView) {
                recycledView = [[UIView alloc] initWithFrame:viewForScroll.bounds];
                
                UIImageView *wheelView = [[UIImageView alloc] initWithFrame:recycledView.bounds];
                wheelView.image = [UIImage imageNamed:@"picker_wheel"];
                [recycledView addSubview:wheelView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, recycledView.bounds.size.width - 8, recycledView.bounds.size.height - 8)];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.tag = 100;
                [recycledView addSubview:imageView];
            }
            
            [self configureView:recycledView atIndex:index];
            [viewForScroll addSubview:recycledView];
            [visibleViews addObject:recycledView];
        }
    }
}

- (void)configureView:(UIView *)view atIndex:(NSUInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(pickerView:titleForItem:)]) {
        UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
        imageView.image = [self.dataSource pickerView:self titleForItem:index];
    }
    
    CGRect frame = view.frame;
    frame.origin.y = viewForScroll.frame.size.height * index;
    view.frame = frame;
}

- (UIView *)dequeueRecycledView
{
	UIView *recycledView = [recycledViews anyObject];
	
    if (recycledView) {
        [recycledViews removeObject:recycledView];
    }
    
    return recycledView;
}

- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL found = NO;
    
    for (UIView *visibleView in visibleViews) {
        int viewIndex = visibleView.frame.origin.y / viewForScroll.frame.size.height;
        if (viewIndex == index) {
            found = YES;
            break;
        }
    }
    
    return found;
}

- (void)reloadData
{
    // Remove;
    for (UIView *visibleView in visibleViews) {
        [visibleView removeFromSuperview];
    }
    
    for (UIView *recycledView in recycledViews) {
        [recycledView removeFromSuperview];
    }

    // Init;
    _selectedItem = 0;
    itemCount = 0;
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInPickerView:)]) {
        itemCount = [self.dataSource numberOfItemsInPickerView:self];
    } else {
        itemCount = 0;
    }
    
    [self scrollToIndex:0 animated:NO];
    viewForScroll.contentSize = CGSizeMake(viewForScroll.frame.size.width, viewForScroll.frame.size.height * itemCount);
    [self tileViews];
}

- (void)determineCurrentItem
{
    CGFloat delta = viewForScroll.contentOffset.y;
    NSUInteger position = round(delta / viewForScroll.frame.size.height);
    _selectedItem = position;
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)]) {
        [self.delegate pickerView:self didSelectItem:_selectedItem];
    }
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [self setSelectedItem:index animated:animated];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    [viewForScroll setContentOffset:CGPointMake(0.0, viewForScroll.frame.size.height * index) animated:animated];
}

- (void)setSelectedItem:(NSUInteger)selectedItem animated:(BOOL)animated
{
    if (selectedItem >= itemCount || selectedItem == _selectedItem) {
        return;
    }
    
    _selectedItem = selectedItem;
    [self scrollToIndex:_selectedItem animated:animated];
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)]) {
        [self.delegate pickerView:self didSelectItem:_selectedItem];
    }
}

@end
