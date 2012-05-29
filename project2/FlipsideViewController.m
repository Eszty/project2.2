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
@synthesize sliderGuessValue = _sliderGuessValue;
@synthesize sliderWordValue = _sliderWordValue;
@synthesize guessValue;
@synthesize wordValue;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MainViewController *main = (MainViewController*)self.delegate;
    
    int type = main.currentGameType;
    NSLog(@"%d",type);
    
    [self.segmentedControl setSelectedSegmentIndex:type]; 
	// Do any additional setup after loading the view, typically from a nib.x
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

- (IBAction)sliderGuessChanged:(id)sender{
    UISlider *slider = (UISlider *)sender; 
    wordValue = slider.value;
    NSString *newText = [[NSString alloc] initWithFormat:@"%1.0f", 
                         slider.value]; 
    self.sliderGuessValue.text = newText; 
    
}

- (IBAction)sliderWordChanged:(id)sender{
    UISlider *sliderWord = (UISlider *)sender; 
    guessValue = sliderWord.value;
    NSString *newText = [[NSString alloc] initWithFormat:@"%1.0f", 
                         sliderWord.value]; 
    self.sliderWordValue.text = newText; 
}


@end
