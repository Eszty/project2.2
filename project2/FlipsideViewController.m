//
//  FlipsideViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize segmentedControl = _segmentedControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}


// Start a new normal hangman game
- (IBAction)startNormalHangman {
    NSLog(@"Normal");
    [(MainViewController*)self.delegate newGame:0];   
}

//Start a new evil hangman game
- (IBAction)startEvilHangman {
    NSLog(@"Evil");
    [(MainViewController*)self.delegate newGame:1];    
}


- (IBAction)choose {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self startNormalHangman];
            break;
        case 1:
            [self startEvilHangman]; 
            break;
        default:
            break;
    }

}



@end
