//
//  MainViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize label = _label;
@synthesize textField = _textField;
@synthesize button = _button;

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

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (void)buttonPressed:(id)sender {
    //self.label.text = self.textField.text;
    
    //NSString *string =[[self textField] text];
    NSInteger count = [[[self textField] text] length];
    self.label.text = [NSString stringWithFormat:@"%i",count];
    
    
    
    self.textField.text = @"";
    //NSInteger count = [string length];
    //self.label.text = [NSString stringWithFormat: @"%i",count];
    
}

@end
