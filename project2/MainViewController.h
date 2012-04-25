//
//  MainViewController.h
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>


@property (nonatomic, strong) IBOutlet UITextField* textField;
@property (nonatomic, strong) IBOutlet UIButton* button;
@property (nonatomic, strong) IBOutlet UILabel* placeholder;
@property (nonatomic, strong) IBOutlet UIButton* newgame;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)newGame:(id)sender;

- (IBAction)showInfo:(id)sender;

- (NSString*)getRandom;

@end
