//
//  APIClient.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "APIClient.h"

#import "Account.h"
#import "User.h"
#import "Post.h"
#import "Mark.h"

// --- Defines ---;
// APIBase URL;
static NSString * const kAPIBaseURLString = @"http://rockcrawlerapps.com/leak/";

// APIClient Class;
@implementation APIClient

// Functions;
#pragma mark - Shared Functions;
+ (instancetype)sharedClient
{
    static APIClient *_sharedClient;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
        
        // Set;
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    return _sharedClient;
}

#pragma mark - User
+ (void)signInFacebookWithUsername:(NSString *)username name:(NSString *)name email:(NSString *)email facebookId:(NSString *)facebookId friends:(NSArray *)friends completion:(void (^)(Account *account, BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"signinfacebook";
    params[@"username"] = username;
    params[@"name"] = name;
    params[@"email"] = email;
    params[@"facebookid"] = facebookId;
    params[@"friends"] = friends;
    
    // POST;
    [[APIClient sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion([Account me], !error);
        }
    }];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(Account *account, BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"login";
    params[@"username"] = username;
    params[@"password"] = password;
    
    // GET;
    [[self sharedClient] GET:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion([Account me], !error);
        }
    }];
}

+ (void)registerWithAvatar:(UIImage *)avatar name:(NSString *)name username:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(Account *account, BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"registerwithemail";
    params[@"name"] = name;
    params[@"username"] = username;
    params[@"email"] = email;
    params[@"password"] = password;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params constructing:^(id<AFMultipartFormData> formData) {
        if (avatar) {
            // Avatar;
            NSData *data = UIImageJPEGRepresentation(avatar, 0.5f);
            
            // Append;
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        }
    } completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion([Account me], !error);
        }
    }];
}

+ (void)forgotPasswordForEmail:(NSString *)email completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"forgotpassword";
    params[@"email"] = email;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)changeProfilePicture:(UIImage *)avatar completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"changeprofilepicture";
    params[@"account"] = [Account me].userID;
    
    // POST;
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params constructing:^(id<AFMultipartFormData> formData) {
        if (avatar) {
            // Avatar;
            NSData *data = UIImageJPEGRepresentation(avatar, 0.5f);
            
            // Append;
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        }
    } completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)saveBiography:(NSString *)biography completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"savebiography";
    params[@"account"] = [Account me].userID;
    params[@"biography"] = biography;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)editProfile:(NSString *)name username:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"editprofile";
    params[@"account"] = [Account me].userID;
    params[@"name"] = name;
    params[@"username"] = username;
    params[@"email"] = email;
    params[@"password"] = password;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)saveProfile:(NSString *)name username:(NSString *)username email:(NSString *)email completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"saveprofile";
    params[@"account"] = [Account me].userID;
    params[@"name"] = name;
    params[@"username"] = username;
    params[@"email"] = email;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)connectToFacebookWithId:(NSString *)facebookId friends:(NSArray *)friends completion:(void (^)(Account *account, BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"connectfacebook";
    params[@"account"] = [Account me].userID;
    params[@"facebookid"] = facebookId;
    if ([friends count]) {
        params[@"friends"] = friends;
    }
    
    // POST;
    [[APIClient sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            [[Account me] setAttributes:responseObject[@"user"]];
        }
        
        if (completion) {
            completion([Account me], !error);
        }
    }];
}

#pragma mark - Post
+ (void)postStatus:(NSString *)comment completion:(void (^)(Post *post))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"poststatus";
    params[@"account"] = [Account me].userID;
    params[@"comment"] = comment;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        Post *post = nil;

        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            // Post;
            post = [[Post alloc] initWithAttributes:responseObject[@"post"]];
            
            // Account;
            [Account me].posts ++;
        }
        
        if (completion) {
            completion(post);
        }
    }];
}

+ (void)repostStatus:(NSString *)comment forPost:(Post *)post completion:(void (^)(Post *post))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"repoststatus";
    params[@"account"] = [Account me].userID;
    params[@"postid"] = post.postID;
    params[@"comment"] = comment;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        Post *post = nil;
        
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            // Post;
            post = [[Post alloc] initWithAttributes:responseObject[@"post"]];
            
            // Account;
            [Account me].posts ++;
        }
        
        if (completion) {
            completion(post);
        }
    }];
}

+ (void)deleteStatus:(Post *)post completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"deletestatus";
    params[@"account"] = [Account me].userID;
    params[@"postid"] = post.postID;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            // Account;
            [Account me].posts --;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)markStatus:(NSString *)mark forPost:(Post *)post completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"markstatus";
    params[@"account"] = [Account me].userID;
    params[@"postid"] = post.postID;
    params[@"mark"] = mark;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            post.mark = [[Mark alloc] initWithAttributes:responseObject[@"marks"]];
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)replyStatus:(NSString *)comment forPost:(Post *)original completion:(void (^)(Post *post))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"replystatus";
    params[@"account"] = [Account me].userID;
    params[@"postid"] = original.postID;
    params[@"comment"] = comment;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        Post *post = nil;
        
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            // Post;
            post = [[Post alloc] initWithAttributes:responseObject[@"post"]];
            
            // Set;
            post.parent = original;
            
            // Add;
            [original.replied addObject:post];
        }
        
        if (completion) {
            completion(post);
        }
    }];
}

+ (void)reportStatus:(Post *)post completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"reportstatus";
    params[@"account"] = [Account me].userID;
    params[@"postid"] = post.postID;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)getFeeds:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfeedposts";
    params[@"account"] = [Account me].userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Post *post = [[Post alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:post];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getActivities:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getactivityposts";
    params[@"account"] = [Account me].userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Post *post = [[Post alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:post];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getSaves:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getsaveposts";
    params[@"account"] = [Account me].userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Post *post = [[Post alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:post];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getAccountMarks:(void (^)(Mark *mark))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getaccountmarks";
    params[@"account"] = [Account me].userID;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        Mark *mark = nil;
        
        if (!error) {
            mark = [[Mark alloc] initWithAttributes:responseObject[@"marks"]];
        }
        
        if (completion) {
            completion(mark);
        }
    }];
}

+ (void)getMarkedPosts:(NSString *)mark last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getmarkedposts";
    params[@"account"] = [Account me].userID;
    params[@"mark"] = mark;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Post *post = [[Post alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:post];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getAccountReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getaccountreposts";
    params[@"account"] = [Account me].userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Post *post = [[Post alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:post];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getAccountReplies:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getaccountreplies";
    params[@"account"] = [Account me].userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Post *post = [[Post alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:post];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

#pragma mark - Follows
+ (void)getFollowers:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *users))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfollowers";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *users = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                User *user = [[User alloc] initWithAttributes:item];
                
                // Add;
                [users addObject:user];
            }
        }
        
        if (completion) {
            completion(users);
        }
    }];
}

+ (void)getFollowings:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *users))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfollowings";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *users = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                User *user = [[User alloc] initWithAttributes:item];
                
                // Add;
                [users addObject:user];
            }
        }
        
        if (completion) {
            completion(users);
        }
    }];
}

+ (void)followUser:(User *)user completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"followuser";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    
    // Animating;
    user.following = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // User;
            user.following = 1;
            user.followers ++;
            
            // Account;
            [Account me].followings ++;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)unfollowUser:(User *)user completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"unfollowuser";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    
    // Animating;
    user.following = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // User;
            user.following = 0;
            user.followers --;
            
            // Account;
            [Account me].followings --;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)blockUser:(User *)user completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"blockuser";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            user.blocking = YES;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)unblockUser:(User *)user completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"unblockuser";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            user.blocking = NO;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)searchUsers:(NSString *)string last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *users))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"searchusers";
    params[@"account"] = [Account me].userID;
    params[@"string"] = string;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *users = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                User *user = [[User alloc] initWithAttributes:item];
                
                // Add;
                [users addObject:user];
            }
        }
        
        if (completion) {
            completion(users);
        }
    }];
}

+ (void)viewUser:(User *)user completion:(void (^)(BOOL successed))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"viewuser";
    params[@"account"] = [Account me].userID;
    params[@"userid"] = user.userID;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            user.peoples ++;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

#pragma mark - APIClient
- (void)GET:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    [self GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#else
    [self GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#endif
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    [self POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#else
    [self POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#endif
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters constructing:(void (^)(id <AFMultipartFormData> formData))block completion:(void (^)(id responseObject, NSError *error))completion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    [self POST:url parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#else
    [self POST:url parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", task.currentRequest.allHTTPHeaderFields);
        
        if (completion) {
            completion(nil, error);
        }
    }];
#endif
}

@end
