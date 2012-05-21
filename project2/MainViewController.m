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
int sizeOfSecretWord;
NSMutableArray *setWith;
NSMutableArray *setWithout;

NSCharacterSet *alphaset;

UILabel *placeholder;
UILabel *placeholderNew;


@synthesize textField = _textField;
@synthesize button = _button;
@synthesize placeholder = _placeholder;
@synthesize guess = _guess;
@synthesize newgame = _newgame;
@synthesize nrguesses = _nrguesses;
@synthesize wrongLetters = _wrongLetters;

@synthesize currentGame = _currentGame;



- (void)viewDidLoad
{
    [super viewDidLoad];
    wrongGuessArray = [[NSMutableArray alloc ] init];
    
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
    
    self.nrguesses.text = @"0";
    
    sizeOfSecretWord = 9;
    setWith = [[NSMutableArray alloc] init];
    //Put all words from plist with the same size as sizeOfSecretWord in setWith array
    for (int i = 0; i < [retWord length]; i++) {
        NSString *temp = [allWords objectAtIndex:i];
        if ([temp length] == [retWord length]) {
            [setWith addObject:temp];
        }
    }
    //NSLog(@"length setWith: %i", [setWith count]);
    
    //Place placeholders
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [retWord length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        
        
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        placeholder.tag = 6;
        
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
    [self newGame:0];
    
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
    NSMutableArray *guessArray = [[NSMutableArray alloc]init];
    if (currentGameType == 1) {
        NSLog(@"Evil algorithm");
        
        //Loop through all the words
        for (int i = 0; i < [allWords count]; i++) {
            NSString *temp = [allWords objectAtIndex:i];
            
            //Size of secret word must be the same as current word from plist
            if ([temp length] == sizeOfSecretWord) {
                int found = 0;
                //NSLog(@"temp = %@", temp);
                //NSLog(@"same size");
                for (int j = 0; j < sizeOfSecretWord; j++) {
                    //NSLog(@"1");
                    //NSLog(@"char at index: %c", [temp characterAtIndex:j]);
                    char subTest = [temp characterAtIndex:j];
                    //NSLog(@"2");
                    NSString *temp2 = [[NSString alloc] initWithFormat:@"%c",subTest]; 
                    //NSLog(@"3");
                    
                    //Choosen letter fits into word from plist
                    //Add to subset with.
                    if ([letter isEqualToString:temp2]) {
                        //NSLog(@"is equal");
                        found = 1;
                        break;
                    }                
                }
                if (found == 1) {
                    [setWith addObject:temp];
                }
                else {
                    [setWithout addObject:temp];
                }
                
            }
            
        }
        //Which set is bigger?
        if ([setWith count] >= [setWithout count]) {
            //The set of words that contain the guessed letter is bigger/as big 
            //then the set of words that don't contain the guessed letter.
            // --> The word contains the letter
            NSLog(@"setWith is bigger");
            //Decide to place letter. Find places of letter.
            for (int i = 0; i < sizeOfSecretWord; i++) {
                char subTest = [retWord characterAtIndex:i];
                NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest]; 
                if ([letter isEqualToString:temp]) {
                    [pArray replaceObjectAtIndex:i withObject:letter];
                }
            }
        }
        else {
            NSLog(@"setWithout is bigger");
        }
        
    }
    //Normal hangman algorithm
    else {

        for (int i = 0; i<[retWord length]; i++) {
            int flag = 0;
            char subTest = [retWord characterAtIndex:i];
            NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest]; 
            if ([letter isEqualToString:temp]) {
                [pArray replaceObjectAtIndex:i withObject:letter];
                flag = 1;
            }
            if(flag == 0){
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
                break;
            }
            
        }
        NSLog(@"%@", guessArray);
        
        [wrongGuessArray addObjectsFromArray:guessArray];
        NSLog(@"%@", wrongGuessArray);
        
        
        self.wrongLetters.text = [NSString stringWithFormat:@"%@", wrongGuessArray];
        
        for(int i = 0; i < [retWord length]; i++){
            placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
            
            placeholderNew.text = [pArray objectAtIndex:i];
            placeholderNew.backgroundColor = [UIColor clearColor];
            placeholderNew.textColor = [UIColor redColor];
            placeholderNew.font = [UIFont systemFontOfSize:30];
            
            placeholderNew.tag = 6;
            
            [self.view addSubview:placeholderNew];
            
            [self.textField resignFirstResponder]; //close keyboard
            
        }
        
        //wrongGuessArray = [self returnArray:guessArray];
        
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
    
    currentGameType = type;

    //delete placeholders
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 6) {
            [subview removeFromSuperview];
        }
    }

    [self viewDidLoad]; //load new word 
    
    //Reset number of guesses
    self.nrguesses.text = @"0";
    
    
    
}


//TODO:
// - Display guessed letters
// - Only alphabetical + only 1 letter
// - Congratulate winner
// - Evil hangman - BUSY ON
// - Put an array of placeholders and right guessed letters. Must be emptied with new game.
// - Settings
// - Read words.plist - DONE
// - Evil hangman: choose random wordlength


@end