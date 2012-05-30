//
//  FlipsideViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize segmentedControl = _segmentedControl;
@synthesize sliderGuessValue = _sliderGuessValue;
@synthesize sliderWordValue = _sliderWordValue;

@synthesize guessSlide;
@synthesize wordSlide;

@synthesize guessValue;
@synthesize wordValue;

@synthesize gametype;

AppDelegate *app;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MainViewController *main = (MainViewController*)self.delegate;
    
    gametype = main.currentGameType;
    NSLog(@"%d",gametype);
    
    [self.segmentedControl setSelectedSegmentIndex:gametype];
    //[self.wordSlide setValue:8];
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
    NSLog(@"wordValueFlip: %d", wordValue);
    NSLog(@"guessFlip: %d", guessValue);
    [(MainViewController*)self.delegate newGame:gametype guess:guessValue word:wordValue];
    
    
}


// Start a new normal hangman game
- (IBAction)startNormalHangman {
    NSLog(@"Normal");
    [(MainViewController*)self.delegate newGame:0 guess:guessValue word:wordValue]; 
}

//Start a new evil hangman game
- (IBAction)startEvilHangman {
    NSLog(@"Evil");
    [(MainViewController*)self.delegate newGame:1 guess:guessValue word:wordValue];  
}


- (IBAction)choose {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            gametype = 0;
            break;
        case 1:
            gametype = 1; 
            break;
        default:
            break;
    }

}

- (IBAction)sliderGuessChanged:(UISlider *)sender{ 
    guessValue = [sender value];
    NSString *newText = [[NSString alloc] initWithFormat:@"%1.0f", 
                         [sender value]]; 
    self.sliderGuessValue.text = newText; 
    
}

- (IBAction)sliderWordChanged:(UISlider*)sender{
    app.wordlength = [sender value];
    NSString *newText = [[NSString alloc] initWithFormat:@"%1.0f", 
                         [sender value]]; 
    self.sliderWordValue.text = newText; 
    //[(MainViewController*)self.delegate.sizeOfSecretword = sliderWord.value]; 
}


@end
