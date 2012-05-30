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
@synthesize sliderGuessValue;
@synthesize sliderWordValue;

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
    
    wordSlide.value = (float)app.wordlength;
    
    [self.guessSlide setValue:(float)app.guesses];

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
    NSLog(@"wordValueFlip: %d", app.wordlength);
    NSLog(@"guessFlip: %d", app.guesses);
    [(MainViewController*)self.delegate newGame:gametype guess:app.guesses word:app.wordlength];
    
    
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
    float floatGuess = [sender value];
    int guessInt = (int)floatGuess;
    app.guesses = guessInt;
    NSString *newText = [[NSString alloc] initWithFormat:@"%d", 
                         guessInt]; 
    self.sliderGuessValue.text = newText; 
    
}

- (IBAction)sliderWordChanged:(UISlider*)sender{
    float floatWord = [sender value];
    int wordInt = (int)floatWord;
    app.wordlength = wordInt;
    NSString *newText = [[NSString alloc] initWithFormat:@"%d", 
                         wordInt]; 
    self.sliderWordValue.text = newText; 
    //[(MainViewController*)self.delegate.sizeOfSecretword = sliderWord.value]; 
}


@end
