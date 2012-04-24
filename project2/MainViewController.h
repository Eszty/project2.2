//
//  MainViewController.h
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel* labelone;
@property (nonatomic, strong) IBOutlet UILabel* labeltwo;
@property (nonatomic, strong) IBOutlet UILabel* labelthree;
@property (nonatomic, strong) IBOutlet UILabel* labelfour;
@property (nonatomic, strong) IBOutlet UILabel* labelfive;
@property (nonatomic, strong) IBOutlet UILabel* labelsix;

@property (nonatomic, strong) IBOutlet UITextField* textField;
@property (nonatomic, strong) IBOutlet UIButton* button;	

- (IBAction)buttonPressed:(id)sender;

- (IBAction)showInfo:(id)sender;

- (NSString*)getRandom;

@end
