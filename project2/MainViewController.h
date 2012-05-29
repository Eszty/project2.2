//
//  MainViewController.h
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextField* textField;
@property (nonatomic, strong) IBOutlet UIButton* button;
@property (nonatomic, strong) IBOutlet UILabel* placeholder;
@property (nonatomic, strong) IBOutlet UIButton* newgame;
@property (nonatomic, strong) IBOutlet UIButton* guess;
@property (nonatomic, strong) IBOutlet UILabel* nrguesses;
@property (nonatomic, strong) IBOutlet UILabel* wrongLetters;

@property (nonatomic, strong) IBOutlet UILabel* currentGame;

@property int currentGameType;




- (IBAction)startNormalHangman:(id)sender;
- (IBAction)buttonPressed:(id)sender;
- (void)newGame:(int)type;
- (IBAction)showInfo:(id)sender;
- (IBAction)guess:(id)sender;
- (void)guessTest:first:(NSString *)ltr second:(NSString *)wrd third:(NSMutableArray *)pArr;
- (void) gameOver:(id)sender;



- (NSString*)getRandom;

@end
