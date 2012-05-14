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

NSString *retWord;
int currentGameType = 0;
NSMutableArray *retArr;
NSMutableArray *wrongGuessArray;
NSArray *allWords; 

NSCharacterSet *alphaset;


@synthesize textField = _textField;
@synthesize button = _button;
@synthesize placeholder = _placeholder;
@synthesize guess = _guess;
@synthesize newgame = _newgame;
@synthesize nrguesses = _nrguesses;

@synthesize currentGame = _currentGame;

//extern NSMutableArray *PArray; 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load plist into array and choose random word
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];    
    allWords = [[NSArray alloc] initWithContentsOfFile:myFile];
    int randomIndex = (arc4random()%[allWords count]);
    retWord = [allWords objectAtIndex:randomIndex];
    NSLog(@"The random word: %@", retWord);
    
    //Set the game title to current game type
    if (currentGameType == 1) {
        self.currentGame.text = @"Evil";        
    }
    //If currentGameType != 0 || 1, set to 0.
    else {
        currentGameType = 0;
        self.currentGame.text = @"Normal";
    }
    
    //Place placeholders
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [retWord length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        [pArray addObject: placeholder.text];
        
        [self.view addSubview:placeholder];
        
        [self.textField resignFirstResponder]; //close keyboard
        
    }
    retArr = [self returnArray:pArray];
    
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

//Creates placeholders for the input word
- (IBAction)buttonPressed:(id)sender {
    
    
}

/*- (NSString*)returnWord:word{
 NSString *wrd = word;
 return wrd;
 }*/

- (NSMutableArray*)returnArray:array{
    NSMutableArray *arr = array;
    return arr;
}

//Capitalize input letter, check if alphabetical and compare with word
- (IBAction)guess:(id)sender {
    alphaset = [NSCharacterSet uppercaseLetterCharacterSet];
    
    NSString *letter = [self.textField.text uppercaseString];
    unichar temp = [letter characterAtIndex:0];
    
    if ([alphaset characterIsMember:temp]) {
        [self guessTestWithFirst:letter second:retArr];
        self.textField.text = @"";
    }
    else {
        UIAlertView *notAlpha = [[UIAlertView alloc] initWithTitle:@"Wrong input" 
                                                           message:@"You only can guess letters" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"Quit game"
                                                 otherButtonTitles:@"OK", nil];
        [notAlpha show];    }
    
    
}

- (void)guessTestWithFirst:(NSString *)letter second:(NSMutableArray *)pArray {
    
    // Evil hangman algorithm
    if (currentGameType == 1) {
        
    }
    //Normal hangman algorithm
    else {
        NSMutableArray *guessArray;
        
        for (int i = 0; i<[retWord length]; i++) {
            char subTest = [retWord characterAtIndex:i];
            NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest]; 
            if ([letter isEqualToString:temp]) {
                [pArray replaceObjectAtIndex:i withObject:letter];
            }
            else {
                [guessArray addObject:temp];
            }
        }
        
        for(int i = 0; i < [retWord length]; i++){
            UILabel *placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
            
            placeholderNew.text = [pArray objectAtIndex:i];
            placeholderNew.backgroundColor = [UIColor clearColor];
            placeholderNew.textColor = [UIColor redColor];
            placeholderNew.font = [UIFont systemFontOfSize:30];
            
            
            [self.view addSubview:placeholderNew];
            
            [self.textField resignFirstResponder]; //close keyboard
            
        }
        //Update number of guesses
        int temp = [self.nrguesses.text intValue];
        temp++;
        if (temp == 10) {
            [self gameOver];
        }
        else  {
            self.nrguesses.text = [NSString stringWithFormat:@"%d", temp];
        }
        wrongGuessArray = [self returnArray:guessArray];
    }
    
    
}

- (void) gameOver {
    UIAlertView *gameover = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:@"You lost the game. Click OK to start a new game" 
                                                      delegate:self 
                                             cancelButtonTitle:@"Quit game"
                                             otherButtonTitles:@"OK", nil];
    [gameover show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self newGame:currentGameType];
    }
    else if([title isEqualToString:@"Quit game"])
    {
        exit(0);
    }
}
// Start a new normal hangman game
- (IBAction)startNormalHangman:(id)sender {
    [self newGame:0];    
}

//Start a new evil hangman game
- (IBAction)startEvilHangman:(id)sender {
    [self newGame:1];    
}


//Type = 0: normal hangman
//Type = 1: evil hangman

- (void)newGame:(int)type {
    //reset nr guesses, load a new random word
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];    
    NSArray *thisArray = [[NSArray alloc] initWithContentsOfFile:myFile];
    int randomIndex = (arc4random()%[thisArray count]);
    retWord = [thisArray objectAtIndex:randomIndex];
    
    //Reset number of guesses
    self.nrguesses.text = @"0";
    
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [retWord length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)  ];
        
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        [pArray addObject: placeholder.text];
        
        [self.view addSubview:placeholder];
        
        [self.textField resignFirstResponder]; //close keyboard
        
    }
    retArr = [self returnArray:pArray];
    //TODO
    //Empty/remove placeholders that hold letters
    //New Game = evil
    if (type == 1){
        currentGameType = 1;
    }
    
    //New game = normal, or if currentGameType != 0 || 1.
    else {
        currentGameType = 1;        
    }
    
}


//TODO:
// - Display guessed letters
// - Only alphabetical + only 1 letter
// - Congratulate winner
// - Evil hangman - BUSY ON
// - Put an array of placeholders and right guessed letters. Must be emptied with new game.
// - Settings
// - Read words.plist - DONE


@end