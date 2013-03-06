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
    
    NSLog(@"newgame after init type %d, max_guesses %d, word_length %d, curr_guesses %d", [current_game get_game_type], [current_game get_max_guesses], [current_game get_word_length], [current_game get_curr_guesses]);

    
    [super viewDidLoad];    
    
    //Set the game title to current game type
    if ([current_game get_game_type] == 0) {
        self.currentGame.text = @"Evil";        
    }
    else {
        self.currentGameType = 1;
        self.currentGame.text = @"Normal";
    }
    
    /* Update guess stats */
    self.nrguesses.text = [NSString stringWithFormat:@"%d", [current_game get_curr_guesses]];
    self.wrongLetters.text = @"";
    
    /* Temp array holding the placeholder characters */
    NSMutableArray *temp_placeholders = [[NSMutableArray alloc] init];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    int begin_coord_x = 10;
    int nr_placeholders = [current_game get_word_length];
    
    /* Check if number of placeholders is even */
    if ((nr_placeholders % 2) == 0) {
        begin_coord_x = (screenWidth / 2) - (nr_placeholders/2)*30;
    }
    /* Uneven */
    else {
        begin_coord_x = (screenWidth / 2) - 15 - ((nr_placeholders/2)-1)*30;
    }
    
    for(int i = 0; i < [current_game get_word_length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 85, 100, 50)];

        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        placeholder.tag = 6;
        
        [temp_placeholders addObject: placeholder.text];
        
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
    NSLog(@"showInfo");
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

//Creates placeholders for the input word
- (IBAction)buttonPressed:(id)sender {
    [self newGame];
}

- (NSMutableArray*)returnArray:array{
    NSMutableArray *arr = array;
    return arr;
}

/* Method that is called once a letter has been guessed. Letters will be capitalized. Non-alphabetical symbols are not allowed. After that the letter is compared to the secret word using the compare_secret_word function */
- (IBAction)guess:(id)sender {    
    NSString *letter = [self.textField.text uppercaseString];

    if ([letter length] == 1) {
        unichar inputChar = [letter characterAtIndex:0];
        alphaset = [NSCharacterSet uppercaseLetterCharacterSet];
        if ([alphaset characterIsMember:inputChar]) {        
            [self compare_secret_word:letter second:retArr];
            self.textField.text = @"";
        }
        else {
            UIAlertView *empty = [[UIAlertView alloc] initWithTitle:@"Wrong input" 
                                                            message:@"You can only guess single letters."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [empty show];    }

    }
    else {
        UIAlertView *empty = [[UIAlertView alloc] initWithTitle:@"Wrong input" 
                                                        message:@"You can only guess single letters."
                                                          delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [empty show];    }
    
    
}

- (void)compare_secret_word:(NSString *)letter second:(NSMutableArray *)pArray {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    int new_letter = 0;
    
    /* Check if letter has already been guessed */
    if([[current_game get_wrong_letters] containsObject:letter] || [[current_game get_right_letters] containsObject:letter]) {
        NSLog(@"already guessed");
        return;
    }
    
    /* In the case of an evil hangman game */
    if ([current_game get_game_type] == 0) {
        NSLog(@"Evil algorithm");
        /* Check if the letter is in the secret word */
        result = [current_game guessLetterEvil:letter];
        
    }
    /* In the case of a normal hangman game */
    else {
        NSLog(@"Normal hangman");
        /* Check if the letter is in the secret word */
        result = [current_game guessLetterNormal:letter];
    }
    
    NSString* best_regex = [[NSString alloc]init];
    int letter_in_word = [[result objectAtIndex:0]intValue];
    if (letter_in_word == 1) {
        best_regex = [result objectAtIndex:1];
        NSLog(@"result %@", best_regex);
    }
    
    /* The letter is in the word */
    if (letter_in_word) {
        NSLog(@"letter is in the word");
        NSLog(@"and the best_regex is %@", best_regex);
        
        /* Update the current guessed word */
        /* Temporary array holding the placeholder characters */
        NSMutableArray *temp_placeholders =[[NSMutableArray alloc]init];
        for (int i = 0; i < [current_game get_word_length]; i++) {
            char subTest = [best_regex characterAtIndex:i];
            NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest];
            if (![temp isEqualToString:@"-"]) {
                [temp_placeholders addObject:temp];
            }
            else {
                [temp_placeholders addObject:@"_"];
            }
        }
        
        /* Update the right guesses stats */
        int temp = [current_game get_right_guesses];
        [current_game set_right_guesses:++temp];
        [current_game set_right_letters:letter];

        
        /* Place placeholders with letters on right places */
        for(int i = 0; i < [current_game get_word_length]; i++){
            placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
            placeholderNew.text = [temp_placeholders objectAtIndex:i];
            placeholderNew.backgroundColor = [UIColor clearColor];
            placeholderNew.textColor = [UIColor redColor];
            placeholderNew.font = [UIFont systemFontOfSize:30];
            
            placeholderNew.tag = 6;
            
            [self.view addSubview:placeholderNew];
            
            [self.textField becomeFirstResponder]; //close keyboard
            
        }
        
    }
    /* The letter isn't in the word */
    else {
        NSLog(@"letter isn't in the word");
        /* Add the wrongly guessed letter into the array of wrong guesses */
        [current_game set_wrong_letters:letter];
        
        /* Update number of guesses */
        int temp = [current_game get_curr_guesses];
        [current_game set_curr_guesses:++temp];
        if (temp == [current_game get_max_guesses]) {
            [self gameOver];
        }
        else  {
            /* Update the number of guessed */
            self.nrguesses.text = [NSString stringWithFormat:@"%d", [current_game get_curr_guesses]];
            
            /* Update the wrongly guessed letters */
            NSString *wrong_guesses= @"";
            for (NSString* item in [current_game get_wrong_letters]) {
                wrong_guesses = [wrong_guesses stringByAppendingString:item];
            }
            self.wrongLetters.text = wrong_guesses;
        }
    }
    if ([current_game get_right_guesses] == [current_game get_word_length]) {
        [self gameWon];
    }
    
    //Normal hangman algorithm
   /* else {

        
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
 */
}

/* Alert that is showed when the game is won */
- (void) gameOver {
    /* Add and show highscore data */
    
    NSArray *localPathsTemp   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *localDocPathTemp    = [localPathsTemp objectAtIndex:0];
    NSString *localFilePathTemp   = [localDocPathTemp stringByAppendingPathComponent:@"highscores.plist"];
    NSMutableDictionary *localDictreadTemp  = [[NSMutableDictionary alloc] initWithContentsOfFile:localFilePathTemp];
    NSLog(@"highscores %@", localDictreadTemp);
    
    int current_score = [current_game get_curr_guesses];
    int first_place = [[localDictreadTemp objectForKey:@"first_place"]intValue];
    int second_place = [[localDictreadTemp objectForKey:@"second_place"]intValue];
    int third_place = [[localDictreadTemp objectForKey:@"third_place"]intValue];
    
    if (current_score > first_place) {
        first_place = current_score;
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%d", current_score] forKey:@"first_place"];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:@"first_place_time"];
    }
    else if (current_score > second_place){
        second_place = current_score;
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%d", current_score] forKey:@"second_place"];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:@"second_place_time"];
    }
    else if (current_score > third_place) {
        third_place = current_score;
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%d", current_score] forKey:@"third_place"];
        [localDictreadTemp setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:@"third_place_time"];
    }    
    NSLog(@"succes? %@", [NSNumber numberWithBool:[localDictreadTemp writeToFile:localFilePathTemp atomically:YES]]);
    
    localDictreadTemp  = [[NSMutableDictionary alloc] initWithContentsOfFile:localFilePathTemp];
    
    NSLog(@"First place: %@ at %@\nSecond place %@ %@\nThird place %@ at %@", [localDictreadTemp objectForKey:@"first_place"], [localDictreadTemp objectForKey:@"first_place_time"],[localDictreadTemp objectForKey:@"second_place"], [localDictreadTemp objectForKey:@"second_place_time"],[localDictreadTemp objectForKey:@"third_place"], [localDictreadTemp objectForKey:@"third_place_time"]);
    
    
    UIAlertView *gameover = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:@"You lost the game. Click OK to start a new game" 
                                                      delegate:self 
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:@"Quit game", nil];
    [gameover show];
}

/* Alert that is shown when the game is lost */
- (void) gameWon {
    UIAlertView *gamewon = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:@"You won! Congratulations!" 
                                                      delegate:self 
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:@"Quit game", nil];
    [gamewon show];
}

/* Method that is called once one of the win/lost game alert buttons has been pressed. Used to close the app once 'Quit game' has been pressed. */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self newGame];
    }
    else if([title isEqualToString:@"Quit game"])
    {
        exit(0);
    }
}

- (void)newGame {
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