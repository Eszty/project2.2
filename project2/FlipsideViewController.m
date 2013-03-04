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
    
    /* Set settings to settings stored in NSUserDefaults */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self.segmentedControl setSelectedSegmentIndex:[[userDefaults valueForKey:@"game_type"] intValue]];
    wordSlide.value = [[userDefaults valueForKey:@"word_length"]floatValue];
    [self.guessSlide setValue:[[userDefaults valueForKey:@"max_guesses"]intValue]];
    NSLog(@"FlipsideViewController game_type %d word_length %f max_guesses %d", [[userDefaults valueForKey:@"game_type"] intValue], [[userDefaults valueForKey:@"word_length"] floatValue],[[userDefaults valueForKey:@"max_guesses"]intValue]);

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

- (IBAction)choose {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [userDefaults setInteger:0 forKey:@"game_type"];
            game_type_setting = 0;
            break;
        case 1:
            game_type_setting = 1;
            [userDefaults setInteger:1 forKey:@"game_type"];
            break;
        default:
            break;
    }

}

- (int) get_game_type_setting {
    return game_type_setting;
}

- (IBAction)sliderGuessChanged:(UISlider *)sender{
    /* Get the value on the slider */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float floatGuess = [sender value];   
    int guessInt = (int)floatGuess;
    
    /* Set instance variable */
    max_guesses_setting = guessInt;
    
    /* Store value in NSUserDefaults */
    [userDefaults setInteger:guessInt forKey:@"max_guesses"];
    [userDefaults synchronize];

    /* Show the value on the slider as a string above the slider */
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",
                         guessInt]; 
    self.sliderGuessValue.text = newText;     
}

-(int) get_max_guesses_setting {
    return max_guesses_setting;
}

- (IBAction)sliderWordChanged:(UISlider*)sender{
    /* Get the value on the slider */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float floatWord = [sender value];
    int wordInt = (int)floatWord;    
    
    /* Set instance variable */
    word_length_setting = wordInt;
    
    /* Store value in NSUserDefaults */
    [userDefaults setInteger:wordInt forKey:@"word_length"];
    [userDefaults synchronize];

    /* Show the value on the slider as a string above the slider */
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",
                         wordInt]; 
    self.sliderWordValue.text = newText;
}

-(int) get_word_length_setting {
    return word_length_setting;
}


@end
