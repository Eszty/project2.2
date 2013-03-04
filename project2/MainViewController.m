//
//  MainViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "game.h"

@interface MainViewController ()


@end

@implementation MainViewController

NSString *retWord;
//int currentGameType = 0;
NSMutableArray *retArr;
NSArray *allWords; 
int sizeOfSecretWord;
NSMutableArray *setWithout;

int winCount = 0;
int possibleWrongGuesses;

NSCharacterSet *alphaset;

UILabel *placeholder;
UILabel *placeholderNew;

NSMutableArray *secretArray;



@synthesize textField = _textField;
@synthesize button = _button;
@synthesize placeholder = _placeholder;
@synthesize guess = _guess;
@synthesize newgame = _newgame;
@synthesize nrguesses = _nrguesses;
@synthesize wrongLetters = _wrongLetters;

@synthesize currentGame = _currentGame;

@synthesize currentGameType = _currentGameType;

AppDelegate *app;
game *current_game;


- (void)viewDidLoad
{    
    /* New game class */
    current_game = [[game alloc] init];
    
    NSLog(@"newgame after init type %d, max_guesses %d, word_length %d, curr_guesses %d, wrong_letters %s", [current_game get_game_type], [current_game get_max_guesses], [current_game get_word_length], [current_game get_curr_guesses], [current_game get_wrong_letters]);

    
    [super viewDidLoad];    
    
    //Set the game title to current game type
    if ([current_game get_game_type] == 0) {
        self.currentGame.text = @"Evil";        
    }
    else {
        self.currentGameType = 1;
        self.currentGame.text = @"Normal";
    }
    
    self.nrguesses.text = [NSString stringWithFormat:@"%d", [current_game get_curr_guesses]];
    
    //Place placeholders
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [current_game get_word_length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        placeholder.tag = 6;
        
        [pArray addObject: placeholder.text];
        
        [self.view addSubview:placeholder];
        
        [self.textField becomeFirstResponder]; //close keyboard
    }    
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
    [self newGame];
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

    if ([letter length] != 0 ) {
        unichar inputChar = [letter characterAtIndex:0];

        if ([alphaset characterIsMember:inputChar]) {
            //unichar temp = [letter characterAtIndex:0];
        
            [self guessTestWithFirst:letter second:retArr];
            self.textField.text = @"";
        }
        else {
            UIAlertView *empty = [[UIAlertView alloc] initWithTitle:@"Wrong input" 
                                                            message:@"You can only guess letters"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [empty show];    }

    }
    else {
        UIAlertView *empty = [[UIAlertView alloc] initWithTitle:@"Wrong input" 
                                                           message:@"You have to type a letter" 
                                                          delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [empty show];    }
    
    
}

- (void)guessTestWithFirst:(NSString *)letter second:(NSMutableArray *)pArray {
    // Evil hangman algorithm
    NSMutableArray *guessArray = [[NSMutableArray alloc]init];
    NSString *regex = @"";
    if (self.currentGameType == 0) {
        NSLog(@"Evil algorithm");
        
        int rightGuess = 0;
        
        [regexes removeAllObjects];
        [nrOfRegexes removeAllObjects];
        
        NSString *tempRegex = @"";
        for (int i = 0; i < sizeOfSecretWord - 1; i++) {
            [tempRegex stringByAppendingString:@"-"];
        }
        [regexes addObject:tempRegex];
        [nrOfRegexes addObject:[NSNumber numberWithInt:0]];
        
        //Loop through all the words
        for (int i = 0; i < [setWith count]; i++) {
            NSString *temp = [setWith objectAtIndex:i];
            regex = @"";
            //Size of secret word must be the same as current word from plist
            if ([temp length] == sizeOfSecretWord) {
                int found = 0;                
                for (int j = 0; j < sizeOfSecretWord; j++) {
                    char subTest = [temp characterAtIndex:j];
                    NSString *temp2 = [[NSString alloc] initWithFormat:@"%c",subTest]; 
                    
                    //Choosen letter fits into word from plist
                    //Add to subset with.
                    if ([letter isEqualToString:temp2]) {
                        regex = [regex stringByAppendingString:letter];
                        found = 1;
                    }  
                    else {
                        regex = [regex stringByAppendingString:@"-"];
                    }
                }
                //Check if regex does already exist
                int flag2 = 0;
                for (int i = 0; i < [regexes count]; i++) {
                    if ([regex isEqualToString:[regexes objectAtIndex:i]]) {
                        flag2 = 1;
                        if (i > [nrOfRegexes count] - 1) {
                            [nrOfRegexes addObject:[NSNumber numberWithInteger:1]];
                        }
                        else {
                            int sum = [[nrOfRegexes objectAtIndex:i] intValue];
                            sum++;
                            [nrOfRegexes replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:sum]];
                        }
                    }
                }
                //regex didn't exist -> add.
                if (flag2 == 0) {
                    [regexes addObject:regex];
                    [nrOfRegexes addObject:[NSNumber numberWithInteger:1]];
                }
                
            }
        }
        
        //find the biggest value in nrOfRegex
        NSString *emptyRegex = @"";
        for (int i = 0; i <sizeOfSecretWord; i++) {
            emptyRegex = [emptyRegex stringByAppendingString:@"-"];
        }
        int max = 0;
        int maxAtIndex = 0;
        NSString *bestRegex = @"";
        if ([nrOfRegexes count] > 2) {
            for (int i = 0; i < [nrOfRegexes count]; i++) {
                if ([[nrOfRegexes objectAtIndex:i] intValue] > max && ![[regexes objectAtIndex:i] isEqualToString:emptyRegex]) {
                    max = [[nrOfRegexes objectAtIndex:i] intValue];
                    maxAtIndex = i;
                    NSLog(@"max: %d, maxAtIndex: %d", max, maxAtIndex);
                }
            }
            bestRegex = [regexes objectAtIndex:maxAtIndex];
            rightGuess = 1;
        }
        //There is but one regex: the empty one. The letter doesn't exist in the word. Wrong guess
        else {
            bestRegex = emptyRegex;
            
        }
        for (int i = 0; i < [nrOfRegexes count]; i++) {
            NSLog(@"nrRegex on %d: %d with regex: %@", i, [[nrOfRegexes objectAtIndex:i] intValue], [regexes objectAtIndex:i]);
        }
        NSLog(@"bestRegex: %@", bestRegex);
        
        int noLetter = 0;
        
        if ([bestRegex isEqualToString:emptyRegex]) {
            noLetter = 1;
        }
        
        //the words that fit the regex, must become the new setWith
        int noFit;
        NSMutableArray *setWithTemp = [[NSMutableArray alloc] init];
        if (noLetter != 1) {
            for (int i = 0; i < [setWith count]; i++) {
                noFit = 0;
                NSString *temp = [setWith objectAtIndex:i];
                for (int j = 0; j < [temp length]; j++) {
                    //split letters into individual chars
                    char subTestTemp = [temp characterAtIndex:j];
                    NSString *tempChar = [[NSString alloc] initWithFormat:@"%c",subTestTemp];
                    char subTestRegex = [bestRegex characterAtIndex:j];
                    NSString *regexChar = [[NSString alloc] initWithFormat:@"%c",subTestRegex];
                    //compare chars
                    if (![tempChar isEqualToString:regexChar] && ![regexChar isEqualToString:@"-"]) {
                        //NSLog(@"no fit. word: %@", temp);
                        noFit = 1;
                    }
                }
                if (noFit == 0) {
                    //NSLog(@"fit: word: %@", temp);
                    [setWithTemp addObject:temp];
                }
            }
            setWith = setWithTemp;
        }
        
        /*for (int i = 0; i < [setWithTemp count]; i++) {
         NSLog(@"%@", [setWithTemp objectAtIndex:i]);
         } */
        
        
        NSLog(@"new setwith length %d", [setWith count]);
        
        
        //place placeholders with letters on right places
        for (int i = 0; i < sizeOfSecretWord; i++) {
            char subTest = [bestRegex characterAtIndex:i];
            NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest]; 
            if (![temp isEqualToString:@"-"]) {
                [pArray replaceObjectAtIndex:i withObject:temp];                
            }
        }
        
        if(rightGuess == 0){
            [guessArray addObject:letter];
            
            //Update number of guesses
            int temp = [self.nrguesses.text intValue];
            temp++;
            if (temp == 10) {
                [self gameOver];
            }
            else  {
                self.nrguesses.text = [NSString stringWithFormat:@"%d", temp];
            }
            NSLog(@"%@", guessArray);
        }        
        [wrongGuessArray addObjectsFromArray:guessArray];        
        
        NSString *wrong_guesses = @"";
        for (NSString *item in wrongGuessArray) {
            //wrong_guesses = [wrong_guesses stringByAppendingString:item];
        }
        
        self.wrongLetters.text = wrong_guesses;
        
        for(int i = 0; i < sizeOfSecretWord; i++){
            placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
            
            placeholderNew.text = [pArray objectAtIndex:i];
            placeholderNew.backgroundColor = [UIColor clearColor];
            placeholderNew.textColor = [UIColor redColor];
            placeholderNew.font = [UIFont systemFontOfSize:30];
            
            placeholderNew.tag = 6;
            
            [self.view addSubview:placeholderNew];
            
            [self.textField becomeFirstResponder]; //close keyboard
            
        }
        if (winCount == [retWord length]) {
            [self gameWon];
        }  
    }
    //Normal hangman algorithm
    else {
        NSLog(@"Normal hangman");
        int flag = 0;
        
        // Check if letter has already been guessed
        for (NSString *item in wrongGuessArray) {
            NSLog(@"item in wrongGuessArray %@", item);
            if ([letter isEqualToString:item]) return;
        }
        
        for (int i = 0; i<[retWord length]; i++) {
            char subTest = [retWord characterAtIndex:i];
            NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest]; 
            if ([letter isEqualToString:temp]) {
                [pArray replaceObjectAtIndex:i withObject:letter];
                flag = 1;
                winCount ++;
                //NSLog(@"%@", wrongGuessArray);
            }
        }
        
        if(flag == 0){
            [guessArray addObject:letter];
            
            //Update number of guesses
            int temp = [self.nrguesses.text intValue];
            temp++;
            if (temp == app.guesses) {
                [self gameOver];
            }
            else  {
                self.nrguesses.text = [NSString stringWithFormat:@"%d", temp];
            }
            NSLog(@"%@", guessArray);
        }        
        [wrongGuessArray addObjectsFromArray:guessArray];
        
        NSString *wrong_guesses = @"";
        for (NSString *item in wrongGuessArray) {
            wrong_guesses = [wrong_guesses stringByAppendingString:item];
        }
        
        self.wrongLetters.text = wrong_guesses;
        
        for(int i = 0; i < [retWord length]; i++){
            placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
            
            placeholderNew.text = [pArray objectAtIndex:i];
            placeholderNew.backgroundColor = [UIColor clearColor];
            placeholderNew.textColor = [UIColor redColor];
            placeholderNew.font = [UIFont systemFontOfSize:30];
            
            placeholderNew.tag = 6;
            
            [self.view addSubview:placeholderNew];
            
            [self.textField becomeFirstResponder]; //close keyboard
            
        }
        
        if (winCount == [retWord length]) {
            [self gameWon];
        }  
    }    
}

- (void) gameOver {
    UIAlertView *gameover = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:@"You lost the game. Click OK to start a new game" 
                                                      delegate:self 
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:@"Quit game", nil];
    [gameover show];
}

- (void) gameWon {
    UIAlertView *gamewon = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:@"You won! Congratulations!" 
                                                      delegate:self 
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:@"Quit game", nil];
    [gamewon show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self newGame:self.currentGameType guess:app.guesses word:app.wordlength];
    }
    else if([title isEqualToString:@"Quit game"])
    {
        exit(0);
    }
}
// Start a new normal hangman game
- (IBAction)startNormalHangman:(id)sender {
    [self newGame:0 guess:app.guesses word:app.wordlength];   
}

//Start a new evil hangman game
- (IBAction)startEvilHangman:(id)sender {
    [self newGame:1 guess:app.guesses word:app.wordlength];    
}


- (void)newGame:(int)type guess:(int)guesses word:(int)wordLength {
    /* Delete placeholders */
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 6) {
            [subview removeFromSuperview];
        }
    }

    /* Create, initialize and load new game */
    [self viewDidLoad];
}

// Close keyboard if tapped somewhere else than textfield
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self.textField resignFirstResponder];
}




//TODO:
// - Display guessed letters
// - Only alphabetical + only 1 letter
// - Congratulate winner
// - Evil hangman - BUSY ON
// - Put an array of placeholders and right guessed letters. Must be emptied with new game. - IS NVM
// - Settings
// - Read words.plist - DONE
// - Evil hangman: choose random wordlength
// - Evil hangman: het is nu niet mogelijk meerdere 'dezelfde' letters in hetzelfde woord te hebben. mbv possiblePositions kiest hij 1 plek waar de geraden letter neergezet wordt. Dit moet aangepast worden.


@end