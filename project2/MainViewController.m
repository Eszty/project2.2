//
//  MainViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "goodGamePlay.h"
#import "evilGamePlay.h"

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
    NSLog(@"viewDidLoad");
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
    
    /* Place placeholders with letters on right places */
    for(int i = 0; i < [current_game get_word_length]; i++){
        placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        placeholder.tag = 6;
        
        [self.view addSubview:placeholder];
        
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
    goodGamePlay *goodPlay = [[goodGamePlay alloc]init];
    evilGamePlay *evilPlay = [[evilGamePlay alloc]init];
    
    /* Check if letter has already been guessed */
    if([[current_game get_wrong_letters] containsObject:letter] || [[current_game get_right_letters] containsObject:letter]) {
        NSLog(@"already guessed");
        return;
    }
    
    /* In the case of an evil hangman game */
    if ([current_game get_game_type] == 0) {
        NSLog(@"Evil algorithm");
        /* Check if the letter is in the secret word */
        NSMutableArray *setWords = [current_game get_setWords];
        NSLog(@"get_setWords %d", [setWords count]);
        int word_length = [current_game get_word_length];
        result = [evilPlay gamePlayDelegate:letter inWords:setWords wordLength:word_length];
    }
    /* In the case of a normal hangman game */
    else {
        NSLog(@"Normal hangman");
        /* Check if the letter is in the secret word */
        result = [goodPlay gamePlayDelegate:letter inWord:[current_game get_secret_word]];
    }
    
    NSString* best_regex = [[NSString alloc]init];
    int double_letter = 0;
    int letter_in_word = [[result objectAtIndex:0]intValue];
    if (letter_in_word == 1) {
        best_regex = [result objectAtIndex:1];
        NSLog(@"result %@", best_regex);
        /* The double letter value was set in a normal game type, so a double letter was found */
        if ([current_game get_game_type] == 1 && [result count] == 3) {
            double_letter = 1;
        }
        else if ([current_game get_game_type] == 0) {
            NSMutableArray *new_setWith = [result objectAtIndex:2];
            [current_game set_setWords:new_setWith];
            /* The double letter value was set in a evil game type */
            if ([result count] == 4) {
                double_letter = 1;
            }
        }
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
        if (double_letter == 1) {
            NSLog(@"double letter, double double increment");
            temp = [current_game get_right_guesses];
            [current_game set_right_guesses:++temp];
        }

        
        /* Place placeholders with letters on right places */
        for(int i = 0; i < [current_game get_word_length]; i++){
            placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
            placeholder.text = [temp_placeholders objectAtIndex:i];
            placeholder.backgroundColor = [UIColor clearColor];
            placeholder.textColor = [UIColor redColor];
            placeholder.font = [UIFont systemFontOfSize:30];
            
            placeholder.tag = 6;
            
            [self.view addSubview:placeholder];
            
        }
        
    }
    /* The letter isn't in the word */
    else {
        NSLog(@"letter isn't in the word");
        /* Add the wrongly guessed letter into the array of wrong guesses */
        [current_game set_wrong_letters:letter];
        
        /* Set the new set of words */
        if ([current_game get_game_type] == 0) {
            NSMutableArray *new_setWith = [result objectAtIndex:1];
            [current_game set_setWords:new_setWith];
        }
        
        /* Update number of guesses */
        int temp = [current_game get_curr_guesses];
        [current_game set_curr_guesses:++temp];
        NSLog(@"curr_guesses %d, max_guesses %d", temp, [current_game get_max_guesses]);
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
}

/* Alert that is showed when the game is won */
- (void) gameOver {
    /* Show highscore data */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int first = [[userDefaults valueForKey:@"first_place"] intValue];
    int second = [[userDefaults valueForKey:@"second_place"] intValue];
    int third = [[userDefaults valueForKey:@"third_place"] intValue];
    
    NSLog(@"before first place %d\nsecond place %d\nthird place %d", first, second, third);

    
    UIAlertView *gameover = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:[NSString stringWithFormat:@"You lost the game.\n First: %d\nSecond: %d\nThird: %d\nClick OK to start a new game", first, second, third]
                                                      delegate:self 
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:@"Quit game", nil];
    [gameover show];
}

/* Alert that is shown when the game is lost */
- (void) gameWon {
    /* Add and show highscore data */
    int current = [current_game get_right_guesses];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int first = [[userDefaults valueForKey:@"first_place"] intValue];
    int second = [[userDefaults valueForKey:@"second_place"] intValue];
    int third = [[userDefaults valueForKey:@"third_place"] intValue];
    
    NSLog(@"before first place %d\nsecond place %d\nthird place %d", first, second, third);
    
    if (current < first) {
        first = current;
        [userDefaults setValue:[NSNumber numberWithInt:first] forKey:@"first_place"];
    }
    else if (current < second ) {
        second = current;
        [userDefaults setValue:[NSNumber numberWithInt:second] forKey:@"first_place"];
    }
    else if (current < third ) {
        third = current;
        [userDefaults setValue:[NSNumber numberWithInt:third] forKey:@"first_place"];
    }
    
    NSLog(@"after first place %d\nsecond place %d\nthird place %d", first, second, third);
    

    UIAlertView *gamewon = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                       message:[NSString stringWithFormat:@"You won! Congratulations!\n First: %d\nSecond: %d\nThird: %d\nClick OK to start a new game", first, second, third]
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive in Mainviewcontroller");
    game *newGame = [current_game load_game_data];
    NSLog(@"newGame from load_game_data\ngame_type %d\n max_guesses %d\n word_length %d \n curr_guesses %d \n right_guesses %d \n wrong_letters %@ \n right_letters %@ \n secret_word %@ \n setWith %@", [newGame get_game_type], [newGame get_max_guesses], [newGame get_word_length], [newGame get_curr_guesses], [newGame get_right_guesses], [newGame get_wrong_letters], [newGame get_right_letters], [newGame get_secret_word], [newGame get_setWords]);
    
    /* Set the current guessed letters in the word */
    NSMutableArray *regex = [[NSMutableArray alloc]init];
    for (int i = 0; i < [newGame get_word_length]; i++) {
        [regex addObject:@"_"];
    }
    if ([newGame get_game_type] == 1) {
        for (NSString *item in [newGame get_right_letters]) {
            for (int j = 0; j < [regex count]; j++) {
                char subTest = [[newGame get_secret_word] characterAtIndex:j];
                NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest];
                if ([item isEqualToString:temp]) {
                    [regex replaceObjectAtIndex:j withObject:temp];
                }
            }
        }
    }
    else {
        for (NSString *item in [newGame get_right_letters]) {
            for (int j = 0; j < [regex count]; j++) {
                char subTest = [[[newGame get_setWords] objectAtIndex:0] characterAtIndex:j];
                NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest];
                if ([item isEqualToString:temp]) {
                    [regex replaceObjectAtIndex:j withObject:temp];
                }
            }
        }

    }    
    current_game = newGame;
    
    //Set the game title to current game type
    if ([current_game get_game_type] == 0) {
        self.currentGame.text = @"Evil";
    }
    else {
        self.currentGameType = 1;
        self.currentGame.text = @"Normal";
    }
    
    /* Update the number of guessed */
    self.nrguesses.text = [NSString stringWithFormat:@"%d", [current_game get_curr_guesses]];
    
    /* Update the wrongly guessed letters */
    NSString *wrong_guesses= @"";
    for (NSString* item in [current_game get_wrong_letters]) {
        wrong_guesses = [wrong_guesses stringByAppendingString:item];
    }
    self.wrongLetters.text = wrong_guesses;
    
    /* Place placeholders with letters on right places */
    for(int i = 0; i < [current_game get_word_length]; i++){
        placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        placeholder.text = [regex objectAtIndex:i];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        placeholder.tag = 6;
        
        [self.view addSubview:placeholder];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive in Mainviewcontroller");
    [current_game save_game_data];
    /* Save current game object to disk */
    /*NSData *encodedGame = [NSKeyedArchiver archivedDataWithRootObject:current_game];
    NSLog(@"1");
    [[NSUserDefaults standardUserDefaults] setObject:encodedGame forKey:@"game_state"];*/

}

// Close keyboard if tapped somewhere else than textfield
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self.textField resignFirstResponder];
}

- (void) set_game_sate:(game*)game_state {
    current_game = game_state;
}
- (game*) get_game_state {
    return current_game;
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