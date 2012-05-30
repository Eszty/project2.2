//
//  AppDelegate.h
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    int wordlength;
    int guesses;
}

@property (strong, nonatomic) UIWindow *window;
@property int wordlength;
@property int guesses;

@property (strong, nonatomic) MainViewController *mainViewController;

@end
