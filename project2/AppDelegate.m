//
//  AppDelegate.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize wordlength;
@synthesize guesses;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    /* Check if app is launched for the first time. Used for (default) settings */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"firstRun"]) {
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        
        /* Set a few game settings as NSUserDefaults */
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:0.0 forKey:@"game_type"];
        [userDefaults setFloat:10.0 forKey:@"max_guesses"];
        [userDefaults setFloat:5.0 forKey:@"word_length"];
        
        /* Set highscores */        
        NSArray *localPathsTemp   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *localDocPathTemp    = [localPathsTemp objectAtIndex:0];
        NSString *localFilePathTemp   = [localDocPathTemp stringByAppendingPathComponent:@"highscores.plist"];
        NSMutableDictionary *localDictreadTemp  = [[NSMutableDictionary alloc] initWithContentsOfFile:localFilePathTemp];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", @"Not set"] forKey:@"first_place"];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", @"Not set"] forKey:@"first_place_time"];
        
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", @"Not set"] forKey:@"second_place"];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", @"Not set"] forKey:@"second_place_time"];
        
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", @"Not set"] forKey:@"third_place"];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", @"Not set"] forKey:@"third_place_time"];
        [userDefaults synchronize];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    
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
    wordlength = 5;
    guesses = 10;
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
