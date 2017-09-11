//
//  Helper.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "Helper.h"

// --- Defines ---;
// Helper Class;
@implementation Helper

// Functions;
#pragma mark - Shared Functions
+ (NSString *)time:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    int iDate = abs([date timeIntervalSinceNow]);
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    const int DAY = 24 * HOUR;

    if (iDate <= 0) {
        return @"1s";
    } else if (iDate == 1) {
        return @"1s";
    } else if (iDate < 1 * MINUTE) {
        return [NSString stringWithFormat:@"%lis", (long)iDate];
    } else if (iDate < 2 * MINUTE) {
        return @"1m";
    } else if (iDate < 1 * HOUR) {
        return  [NSString stringWithFormat:@"%im", iDate/MINUTE];
    } else if (iDate < 2 * HOUR) {
        return @"1h";
    } else if (iDate < 24 * HOUR) {
        return [NSString stringWithFormat:@"%ih", iDate/HOUR];
    } else if (iDate < 48 * HOUR) {
        return @"1d";
    } else if (iDate < 30 * DAY) {
        return [NSString stringWithFormat:@"%id", iDate/DAY];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd, yyyy"];
        return [formatter stringFromDate:date];
    }
    
    return @"Error parsing date";
}

+ (NSString *)timeWithAgo:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    int iDate = abs([date timeIntervalSinceNow]);
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    const int DAY = 24 * HOUR;
    
    if (iDate <= 0) {
        return @"1s ago";
    } else if (iDate == 1) {
        return @"1s ago";
    } else if (iDate < 1 * MINUTE) {
        return [NSString stringWithFormat:@"%lis ago", (long)iDate];
    } else if (iDate < 2 * MINUTE) {
        return @"1m ago";
    } else if (iDate < 1 * HOUR) {
        return  [NSString stringWithFormat:@"%im ago", iDate/MINUTE];
    } else if (iDate < 2 * HOUR) {
        return @"1h ago";
    } else if (iDate < 24 * HOUR) {
        return [NSString stringWithFormat:@"%ih ago", iDate/HOUR];
    } else if (iDate < 48 * HOUR) {
        return @"1d ago";
    } else if (iDate < 30 * DAY) {
        return [NSString stringWithFormat:@"%id ago", iDate/DAY];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd, yyyy"];
        return [formatter stringFromDate:date];
    }
    
    return @"Error parsing date";
}

@end
