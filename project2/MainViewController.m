//
//  MainViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"


@interface MainViewController ()


@end

@implementation MainViewController

NSString *retWord;
//int currentGameType = 0;
NSMutableArray *retArr;
NSMutableArray *wrongGuessArray;
NSArray *allWords; 
int sizeOfSecretWord;
NSMutableArray *setWith;
NSMutableArray *setWithout;
NSMutableArray *regexes;
NSMutableArray *nrOfRegexes;
//int flag;
int winCount = 0;

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


- (void)viewDidLoad
{
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [super viewDidLoad];    
        
    secretArray = [[NSMutableArray alloc] init];
            
    wrongGuessArray = [[NSMutableArray alloc ] init];
    
    
    NSLog(@"FLIP: %d", app.wordlength);
    
    if (app.wordlength != 0) {
        NSLog(@"poep");
        sizeOfSecretWord = app.wordlength;
    }
    else {
        sizeOfSecretWord = 5;
    }
    
    
    //Load plist into array and choose random word
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];    
    allWords = [[NSArray alloc] initWithContentsOfFile:myFile];
    
    NSLog(@"SECRET: %d", sizeOfSecretWord);
    
    for (int i=0; i<[allWords count]; i++) {
        if ([[allWords objectAtIndex:i] length] == sizeOfSecretWord) {
            [secretArray addObject:[allWords objectAtIndex:i]];
        }
    }
    
    int randomIndex = (arc4random()%[secretArray count]);
    
    
    retWord = [secretArray objectAtIndex:randomIndex];
    NSLog(@"The random word: %@", retWord);
    
    //Set the game title to current game type
    if (self.currentGameType == 1) {
        self.currentGame.text = @"Evil";        
    }
    //If currentGameType != 0 || 1, set to 0.
    else {
        self.currentGameType = 0;
        self.currentGame.text = @"Normal";
    }
    
    self.nrguesses.text = @"0";
    
    //sizeOfSecretWord = [flip wordValue];

    NSLog(@"word: %d", sizeOfSecretWord);
    
    //sizeOfSecretWord = [retWord length];
    
    regexes = [[NSMutableArray alloc] init];
    NSString *tempRegex = @"";
    for (int i = 0; i < sizeOfSecretWord; i++) {
        [tempRegex stringByAppendingString:@"-"];
    }
    [regexes addObject:tempRegex];
    [nrOfRegexes addObject:0];
    
    setWith = [[NSMutableArray alloc] init];
    //Put all words from plist with the same size as sizeOfSecretWord in setWith array
    for (int i = 0; i < [allWords count]; i++) {
        NSString *temp = [allWords objectAtIndex:i];
        if ([temp length] == sizeOfSecretWord) {
            [setWith addObject:temp];
        }
    }
    NSLog(@"length setWith: %i", [setWith count]);
    
    //Place placeholders
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < sizeOfSecretWord; i++){
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
    [self newGame:self.currentGameType guess:app.wordlength word:app.wordlength];
    
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
                                                  cancelButtonTitle:@"Quit game"
                                                  otherButtonTitles:@"OK", nil];
            [empty show];    }

    }
    else {
        UIAlertView *empty = [[UIAlertView alloc] initWithTitle:@"Wrong input" 
                                                           message:@"You have to type a letter" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"Quit game"
                                                 otherButtonTitles:@"OK", nil];
        [empty show];    }
    
    
}

- (void)guessTestWithFirst:(NSString *)letter second:(NSMutableArray *)pArray {
    
    
    
    // Evil hangman algorithm
    NSMutableArray *guessArray = [[NSMutableArray alloc]init];

    //NSMutableArray *guessArray;
    NSMutableArray *tempSetWith = [[NSMutableArray alloc] init];
    NSMutableArray *tempSetWithout = [[NSMutableArray alloc] init];
    
    int counter = 0;
    NSString *regex = @"";
    if (self.currentGameType == 1) {
        NSLog(@"Evil algorithm");
        
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
                        //NSLog(@"regex: %@", regex);
                        found = 1;
                    }  
                    else {
                        regex = [regex stringByAppendingString:@"-"];
                        //NSLog(@"regex: %@", regex);
                    }
                }
                //Check if regex does already exist
                int flag2 = 0;
                for (int i = 0; i < [regexes count]; i++) {
                    //NSLog(@"for++");
                    if ([regex isEqualToString:[regexes objectAtIndex:i]]) {
                        flag2 = 1;
                        int sum = [[nrOfRegexes objectAtIndex:i] intValue];
                        sum++;
                        [nrOfRegexes replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:sum]];
                    }
                }
                //regex didn't exist -> add.
                if (flag2 == 0) {
                    [regexes addObject:regex];
                }
                
                if (found == 1) {
                    [tempSetWith addObject:temp];
                }
                else {
                    //NSLog(@"add to tempsetwithout");
                    [tempSetWithout addObject:temp];
                }
                
            }
        }
        for (int i = 0; i < [regexes count]; i++) {
            NSLog(@"regex: %@\n", [regexes objectAtIndex:i]);
        }
        for (int i = 0; i < [regexes count]; i++) {
            NSLog(@"regex: %@\n", [regexes objectAtIndex:i]);
        }
        
        NSLog(@"setwith: %d, setWithout: %d", [tempSetWith count], [tempSetWithout count]);
        //Which set is bigger?
        if ([tempSetWith count] >= [tempSetWithout count]) {
            //The set of words that contain the guessed letter is bigger/as big 
            //then the set of words that don't contain the guessed letter.
            // --> The word contains the letter
            /*NSLog(@"tempsetWith is bigger");
            setWith = tempSetWith;
            //Decide to place letter. Find places of letter.
            NSMutableArray *possiblePositions = [[NSMutableArray alloc] initWithCapacity:sizeOfSecretWord];
            for (int i = 0; i < sizeOfSecretWord; i++) {
                [possiblePositions insertObject:[NSNumber numberWithInteger:0] atIndex:i];
            }
            for (int j = 0; j < [setWith count]; j++) {
                NSString *temp = [setWith objectAtIndex:j];
                //NSLog(@"4");
                //NSLog(@"possiblepositions value before: %d", [possiblePositions count]);
                for (int i = 0; i < sizeOfSecretWord; i++) {
                    char subTest = [temp characterAtIndex:i];
                    //NSLog(@"5");
                    NSString *temp2 = [[NSString alloc] initWithFormat:@"%c",subTest]; 
                    //NSLog(@"7");
                    if ([letter isEqualToString:temp2]) {                        
                        int sum = [[possiblePositions objectAtIndex:i] intValue];
                        sum++;
                        [possiblePositions replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:sum]];
                        break;
                    }
                }
            }
            NSLog(@"positions count");
            NSLog(@"size of possiblepostitions: %d", [possiblePositions count]);
            for (int i = 0; i < [possiblePositions count]; i++) {
                NSLog(@"at index: %d, value: %d", i, [[possiblePositions objectAtIndex:i] intValue]);
            }*/
        }
        else {
            NSLog(@"tempsetWithout is bigger");
            setWith = tempSetWithout;
        }
               
    }
    //Normal hangman algorithm
    else {
        int flag = 0;
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
            if (temp == 10) {
                [self gameOver];
            }
            else  {
                self.nrguesses.text = [NSString stringWithFormat:@"%d", temp];
            }
            NSLog(@"%@", guessArray);
        }
        
        [wrongGuessArray addObjectsFromArray:guessArray];        
        
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
        
        if (winCount == [retWord length]) {
            [self gameWon];
        }  
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

- (void) gameWon {
    UIAlertView *gamewon = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:@"You won! Congratulations!" 
                                                      delegate:self 
                                             cancelButtonTitle:@"Quit game"
                                             otherButtonTitles:@"OK", nil];
    [gamewon show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self newGame:self.currentGameType guess:app.wordlength word:app.wordlength];
    }
    else if([title isEqualToString:@"Quit game"])
    {
        exit(0);
    }
}
// Start a new normal hangman game
- (IBAction)startNormalHangman:(id)sender {
    [self newGame:0 guess:app.wordlength word:app.wordlength];   
}

//Start a new evil hangman game
- (IBAction)startEvilHangman:(id)sender {
    [self newGame:1 guess:app.wordlength word:app.wordlength];    
}


//Type = 0: normal hangman
//Type = 1: evil hangman

- (void)newGame:(int)type guess:(int)guesses word:(int)wordLength{
    
    self.currentGameType = type;
    sizeOfSecretWord = wordLength;

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