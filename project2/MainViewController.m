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

@synthesize labelone = _labelone;
@synthesize labeltwo = _labeltwo;
@synthesize labelthree = _labelthree;
@synthesize labelfour = _labelfour;
@synthesize labelfive = _labelfive;
@synthesize labelsix = _labelsix;

@synthesize textField = _textField;
@synthesize button = _button;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableDictionary *wordsArray = [[NSMutableDictionary alloc] initWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    
    //Get item10 with value 'aardvark'
    NSObject *randomWord = [wordsArray objectForKey:@"item 6"];
    NSLog(@"%@", randomWord);

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
    if ([self.textField.text isEqualToString:@"s"])	 {
        self.labelone.text = @"s";
        self.textField.text = @"";
    }
    else if ([self.textField.text isEqualToString:@"c"]) {
        self.labeltwo.text = @"c";
        self.textField.text = @"";
    }
    else if ([self.textField.text isEqualToString:@"h"]) {
        self.labelthree.text = @"h";
        self.textField.text = @"";
    }
    else if ([self.textField.text isEqualToString:@"a"]) {
        self.labelfour.text = @"a";
        self.labelfive.text = @"a";
        self.textField.text = @"";
    }
    else if ([self.textField.text isEqualToString:@"p"]) {
        self.labelsix.text = @"p";
        self.textField.text = @"";
    }
    else {
        self.textField.text = @"";
    }
}



@end
