//
//  APIClient.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
#import "AFHTTPRequestOperationManager.h"
#else
#import "AFHTTPSessionManager.h"
#endif

// --- Classes ---;
@class Account;
@class User;
@class Post;
@class Mark;

// --- Defines ---;
// APIClient Class;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
@interface APIClient : AFHTTPRequestOperationManager
#else
@interface APIClient : AFHTTPSessionManager
#endif

// Functions;
+ (instancetype)sharedClient;

// Account;
+ (void)signInFacebookWithUsername:(NSString *)username name:(NSString *)name email:(NSString *)email facebookId:(NSString *)facebookId friends:(NSArray *)friends completion:(void (^)(Account *account, BOOL successed))completion;
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(Account *account, BOOL successed))completion;
+ (void)registerWithAvatar:(UIImage *)avatar name:(NSString *)name username:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(Account *account, BOOL successed))completion;
+ (void)forgotPasswordForEmail:(NSString *)email completion:(void (^)(BOOL successed))completion;
+ (void)changeProfilePicture:(UIImage *)avatar completion:(void (^)(BOOL successed))completion;
+ (void)saveBiography:(NSString *)biography completion:(void (^)(BOOL successed))completion;
+ (void)editProfile:(NSString *)name username:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL successed))completion;
+ (void)saveProfile:(NSString *)name username:(NSString *)username email:(NSString *)email completion:(void (^)(BOOL successed))completion;
+ (void)connectToFacebookWithId:(NSString *)facebookId friends:(NSArray *)friends completion:(void (^)(Account *account, BOOL successed))completion;

// Posts;
+ (void)postStatus:(NSString *)comment completion:(void (^)(Post *post))completion;
+ (void)repostStatus:(NSString *)comment forPost:(Post *)post completion:(void (^)(Post *post))completion;
+ (void)replyStatus:(NSString *)comment forPost:(Post *)post completion:(void (^)(Post *post))completion;
+ (void)markStatus:(NSString *)mark forPost:(Post *)post completion:(void (^)(BOOL successed))completion;
+ (void)deleteStatus:(Post *)post completion:(void (^)(BOOL successed))completion;
+ (void)reportStatus:(Post *)post completion:(void (^)(BOOL successed))completion;


+ (void)getFeeds:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getActivities:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getSaves:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getAccountMarks:(void (^)(Mark *mark))completion;
+ (void)getMarkedPosts:(NSString *)mark last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getAccountReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getAccountReplies:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;

// Follows;
+ (void)getFollowers:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *users))completion;
+ (void)getFollowings:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *users))completion;
+ (void)followUser:(User *)user completion:(void (^)(BOOL successed))completion;
+ (void)unfollowUser:(User *)user completion:(void (^)(BOOL successed))completion;
+ (void)blockUser:(User *)user completion:(void (^)(BOOL successed))completion;
+ (void)unblockUser:(User *)user completion:(void (^)(BOOL successed))completion;
+ (void)searchUsers:(NSString *)string last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *users))completion;
+ (void)viewUser:(User *)user completion:(void (^)(BOOL successed))completion;

@end
