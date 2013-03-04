//
//  FlipsideViewController.h
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  Testcomment
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController {
    int game_type_setting;
    int max_guesses_setting;
    int word_length_setting;
}
    
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UILabel* sliderGuessValue;
@property (nonatomic, strong) IBOutlet UILabel* sliderWordValue;

@property (nonatomic, retain) IBOutlet UISlider* guessSlide;
@property (nonatomic, retain) IBOutlet UISlider* wordSlide;


@property int guessValue;
@property int wordValue;

@property int gametype;

- (IBAction)sliderGuessChanged:(id)sender;
- (IBAction)sliderWordChanged:(id)sender;

- (IBAction)choose;

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end

