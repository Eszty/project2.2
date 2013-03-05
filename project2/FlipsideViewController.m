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
    NSLog(@"viewdidload");
    /* Set settings to settings stored in NSUserDefaults */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self.segmentedControl setSelectedSegmentIndex:[[userDefaults valueForKey:@"game_type"] intValue]];
    
    /* Word length */
    NSLog(@"current value of wordslide %f", self.wordSlide.value);
    [self.wordSlide setValue:[[userDefaults valueForKey:@"word_length"]floatValue]];
    NSLog(@"userdefaults word_length %f",[[userDefaults valueForKey:@"word_length"]floatValue]);
    NSLog(@"current value of wordslide %f", self.wordSlide.value);

    /* Show the value on the slider as a string above the slider */
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",
                         [[userDefaults valueForKey:@"word_length"]intValue]];
    self.sliderWordValue.text = newText;

    
    /* Max number of guesses */
    NSLog(@"current value of guessslide %f", self.guessSlide.value);
    [self.guessSlide setValue:[[userDefaults valueForKey:@"max_guesses"]floatValue]];
    NSLog(@"userdefaults max guesses %f",[[userDefaults valueForKey:@"max_guesses"]floatValue]);
    NSLog(@"current value of guessslide %f", self.guessSlide.value);
    //[self.guessSlide setValue:[[userDefaults valueForKey:@"max_guesses"]floatValue]];
    /* Show the value on the slider as a string above the slider */
    newText = [[NSString alloc] initWithFormat:@"%d",
                        [[userDefaults valueForKey:@"max_guesses"]intValue]];
    self.sliderGuessValue.text = newText;
    
    
    [super viewDidLoad];

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    /* Store game type value in NSUserDefaults */
    [userDefaults setInteger:game_type_setting forKey:@"game_type"];
    
    /* Store max guesses value in NSUserDefaults */
    [userDefaults setInteger:max_guesses_setting forKey:@"max_guesses"];
    [userDefaults synchronize];
        
    /* Store value in NSUserDefaults */
    [userDefaults setInteger:word_length_setting forKey:@"word_length"];
    [userDefaults synchronize];

    [self.delegate flipsideViewControllerDidFinish:self];
    
}

- (IBAction)choose {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            game_type_setting = 0;
            break;
        case 1:
            game_type_setting = 1;
            break;
        default:
            break;
    }

}

- (int) get_game_type_setting {
    return game_type_setting;
}

/* Max number of guesses */
- (IBAction)sliderGuessChanged:(UISlider *)sender{
    /* Get the value on the slider */
    float floatGuess = [sender value];   
    int guessInt = (int)floatGuess;
    
    /* Set instance variable */
    max_guesses_setting = guessInt;
    
    /* Show the value on the slider as a string above the slider */
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",
                         guessInt];
    self.sliderGuessValue.text = newText;     
}

-(int) get_max_guesses_setting {
    return max_guesses_setting;
}

/* Word length */
- (IBAction)sliderWordChanged:(UISlider*)sender{
    /* Get the value on the slider */
    float floatWord = [sender value];
    int wordInt = (int)floatWord;    
    
    /* Set instance variable */
    word_length_setting = wordInt;

    /* Show the value on the slider as a string above the slider */
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",
                         wordInt]; 
    self.sliderWordValue.text = newText;
}

-(int) get_word_length_setting {
    return word_length_setting;
}


@end
