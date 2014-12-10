//
//  ndAppDelegate.m
//  NDDeviceAPI
//
//  Created by CocoaPods on 12/02/2014.
//  Copyright (c) 2014 ilikeido. All rights reserved.
//

#import "ndAppDelegate.h"
#import <NDUserAPI.h>
#import <NDAPIManager.h>
#import <CommonCrypto/CommonDigest.h>
#import "LK_NSDictionary2Object.h"
#import <AFNetworking.h>
#import <objc/runtime.h>
#import <objc/message.h>


#define APP_KEY @"c2674528e7fab0e856d9b4a563168f19"
#define SECRET_KEY @"02a2025b903e585efff6b2fe73b15675"

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end

@implementation NSString (md5)

-(NSString *) md5HexDigest

{
    
    const char *original_str = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
    
}

@end


@implementation ndAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NDAPIManager startWithAppKey:APP_KEY
                        secretKey:SECRET_KEY];
    NDLoginParams *params = [[NDLoginParams alloc]init];
    params.user_name = @"ilikeido";
    params.password = [@"123456" md5HexDigest];
    [NDUserAPI loginWithParams:params completionBlockWithSuccess:^(NDLoginResult *result) {
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
