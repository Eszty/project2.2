//
//  project2Tests.m
//  project2Tests
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "project2Tests.h"
#import "game.h"
#import "goodGamePlay.h"
#import "evilGamePlay.h"

@implementation project2Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/* Test the evil game mode - find biggest set that does or does not contain the letter */
-(void) test_evil_play_mode {
    evilGamePlay *evilgame = [[evilGamePlay alloc]init];
    
    /* Load the test word set */
    NSMutableArray *setWith = [[NSMutableArray alloc]initWithObjects:@"BOAR", @"DUCK", @"BEAR", @"DEER", @"HARE", nil];
    
    /* Guess the letter 'Z' */
    NSMutableArray *result = [evilgame gamePlayDelegate:@"Z" inWords:setWith wordLength:4];
    /* Test if 'Z' is wrong guessed */
    STAssertTrue([[result objectAtIndex:0]intValue] == 0, @"The letter Z shouldn't be in the word, but it is");
    /* The set after the wrong guessed 'Z' should contain 5 words. Test this */
    STAssertTrue([[result objectAtIndex:1]count] == 5, @"The size of the set after e should be 5, but it isn't");
    
    /* Guess the letter 'E'. Sets are as follows:
     ----, which contains BOAR and DUCK
     -E--, which contains BEAR
     -EE-, which contains DEER
     ---E, which contains HARE
    So the letter 'E' musn't be in the set and must be wrongly guessed */
    
    result = [evilgame gamePlayDelegate:@"E" inWords:setWith wordLength:4];
    /* Test if 'E' is wrong guessed */
    STAssertTrue([[result objectAtIndex:0]intValue] == 0, @"The letter E shouldn't be in the word, but it is");
    /* The set after the wrong guessed 'E' should contain two words. Test this */
    STAssertTrue([[result objectAtIndex:1]count] == 2, @"The size of the set after e should be 2, but it isn't");
    
    /* The words that are left are BOAR and DUCK. Now guess the letter 'B'. This should be a correct letter (50/50 = word contains letter) */
    result = [evilgame gamePlayDelegate:@"B" inWords:[result objectAtIndex:1] wordLength:4];
    /* Test if 'B' is right guessed and the regex is B--- */
    STAssertTrue([[result objectAtIndex:0]intValue] == 1, @"The letter B should be in the word, but it isn't");
    STAssertTrue([[result objectAtIndex:1] isEqualToString:@"B---"], @"The regex should look like B---, but it doesn't");
    /* Only the word BOAR should be left in the set of words. Check this */
    STAssertTrue([[result objectAtIndex:2]count] == 1, @"Only the word BOAR should be left, but it isn't");
}

/* Test the normal game mode - find a letter in a guessed word */
-(void) test_good_play_mode {
    goodGamePlay *goodgame = [[goodGamePlay alloc]init];
    NSString *secret_word = @"thegreatwhitefox";

    NSString *right_guess = @"w";
    NSString *wrong_guess = @"z";
    
    NSString *secret_word_after_right_guess = @"--------w-------";
    
    NSMutableArray *result = [goodgame gamePlayDelegate:right_guess inWord:secret_word];
    
    STAssertTrue(([[result objectAtIndex:0]intValue] == 1 && [[result objectAtIndex:1] isEqualToString:secret_word_after_right_guess]), @"Letter %@ in secret word %@ was not found, but it should have been found", right_guess, secret_word);
    
    result = [goodgame gamePlayDelegate:wrong_guess inWord:secret_word];
    
    STAssertTrue([[result objectAtIndex:0]intValue] == 0, @"Letter %@ in secret word %@ was not found, but it should have been found", right_guess, secret_word);
}

-(void) test_new_game_contents {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    game* newGame = [[game alloc]init];
    /* Test the value of the game type */
    STAssertEquals([newGame get_game_type], [[userDefaults objectForKey:@"game_type"] intValue], @"Expected game type %d, but it was %d", [[userDefaults objectForKey:@"game_type"] intValue], [newGame get_game_type]);
    
    /* Test the number of maximum guesses */
    STAssertEquals([newGame get_max_guesses], [[userDefaults objectForKey:@"max_guesses"] intValue], @"Expected maximum guesses %d, but it was %d", [[userDefaults objectForKey:@"max_guesses"] intValue], [newGame get_max_guesses]);
    
    /* Test the word length */
    STAssertEquals([newGame get_word_length], [[userDefaults objectForKey:@"word_length"] intValue], @"Expected word length %d, but it was %d", [[userDefaults objectForKey:@"word_length"] intValue], [newGame get_word_length]);

    /* Test the current ammount of wrong guesses */
    STAssertEquals([newGame get_curr_guesses], 0, @"Expected current ammount of wrong guesses %d, but it was %d", 0, [newGame get_curr_guesses]);

    /* Test the current amount of right guesses */
    STAssertEquals([newGame get_right_guesses], 0, @"Expected current ammount of right guesses %d, but it was %d", 0, [newGame get_right_guesses]);
    
    /* Test the wrong guesses letters */
    STAssertTrue([[newGame get_wrong_letters]count] == 0, @"Expected number of wrong guessed letters %d, but it was %d", 0, [[newGame get_wrong_letters]count]);
    
    /* Test the right guessed letters */
    STAssertTrue([[newGame get_right_letters]count] == 0, @"Expected number of right guessed letters %d, but it was %d", 0, [[newGame get_right_letters]count]);

    if ([newGame get_game_type] == 0) {
        /* In the case of an evil game: test the set of words with word_length */
        STAssertTrue([[newGame get_setWords]count]>0, @"Expected was that the length of setWords was >0, but it is %d", [[newGame get_setWords]count]);
    }
    else {
        /* In the case of a normal game: test the (length of) the secret word */
        STAssertTrue([[newGame get_secret_word]length] == [newGame get_word_length], @"Expected length of secret word was %d, but it was %d", [newGame get_word_length], [[newGame get_secret_word]length]);
    }
}



@end
