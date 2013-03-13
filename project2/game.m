//
//  game.m
//  project2
//
//  Created by Sammy Odenhoven on 2/27/13.
//
//

#import "game.h"
#import "FlipsideViewController.h"

@implementation game

/* Create a new instance of the game */
-(game*) newGame {
    game *newGame;
    newGame = [[game alloc] init];
    return newGame;
}

/* Initialize an (new) instance of the game */
-(game*)init {
    /* If there's an issue with the super init, don't continue initializing */
    if (!(self = [super init])) {
        return nil;
    }
    
    /* Initialize the game using the settings, stored in NSUserDefaults */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    game_type = [[userDefaults objectForKey:@"game_type"] intValue];
    max_guesses = [[userDefaults objectForKey:@"max_guesses"] intValue];
    word_length = [[userDefaults objectForKey:@"word_length"] intValue];
    curr_guesses = 0;
    wrong_letters = [[NSMutableArray alloc]init];
    right_letters = [[NSMutableArray alloc]init];
    bestRegex = @"";
    
    /* Read the word.plist file into an array */
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    //NSArray *allWords = [[NSArray alloc] initWithContentsOfFile:myFile];
    NSArray *allWords = [[NSArray alloc] initWithObjects:@"BOAR", @"DUCK", @"BEAR", @"DEER", @"HARE", nil];
    
    /* If this is a normal hangman game, choose a secret word */
    if (game_type == 1) {
        /* Load plist into array and choose random word */
        NSMutableArray *array_with_word_size = [[NSMutableArray alloc]init];
        
        /* Find all words with a length that is the same as the word_length setting */
        for (int i=0; i<[allWords count]; i++) {
            
            if ([[allWords objectAtIndex:i] length] == word_length) {
                [array_with_word_size addObject:[allWords objectAtIndex:i]];
            }
        }
        int randomIndex = (arc4random()%[array_with_word_size count]);
        secret_word = [NSString stringWithFormat:@"%@", [array_with_word_size objectAtIndex:randomIndex]];
        NSLog(@"The secret word is %@", secret_word);
    }
    /* This is an evil hangman game */
    else {
        /* Store all words of the word length setting in a list that we need for the evil hangman algorithm */
        setWith = [[NSMutableArray alloc]init];
        for (int i = 0; i < [allWords count]; i++) {
            NSString *temp = [allWords objectAtIndex:i];
            if ([temp length] == word_length) {
                [setWith addObject:temp];
            }
        }
        NSLog(@"setWith after init %d", [setWith count]);
        
        /* Create an empty regex, used for the evil hangman algorithm */
        /*egexes = [[NSMutableArray alloc] init];
        nrOfRegexes = [[NSMutableArray alloc] init];        
        NSString *tempRegex = @"";
        for (int i = 0; i < word_length; i++) {
            [tempRegex stringByAppendingString:@"-"];
        }
        [regexes addObject:tempRegex];
        [nrOfRegexes addObject:[NSNumber numberWithInt:0]];*/
    }
    
    return self;
}

-(int) get_game_type {
    return game_type;
}

-(int) get_max_guesses {
    return max_guesses;
}

-(int) get_word_length {
    return word_length;
}

-(NSString*) get_secret_word {
    return secret_word;
}

-(int) get_curr_guesses {
    return curr_guesses;
}

-(void) set_curr_guesses:(int)value {
    curr_guesses = value;
}

-(NSMutableArray*) get_wrong_letters {
    return wrong_letters;
}

-(void) set_wrong_letters:(NSString*)letter {
    [wrong_letters addObject:letter];
}

-(int) get_right_guesses {
    return right_guesses;
}

-(void) set_right_guesses:(int)value {
    right_guesses = value;
}

-(NSMutableArray*) get_right_letters {
    return right_letters;
}

-(void) set_right_letters:(NSString*)letter {
    [right_letters addObject:letter];
}

-(NSMutableArray*) get_setWords {
    return setWith;
}
-(void) set_setWords:(NSMutableArray*)setWords {
    setWith = setWords;
    NSLog(@"lenght of new setWith %d", [setWith count]);
}

-(NSString*) get_bestRegex {
    return bestRegex;
}

-(void) set_bestRegex:(NSString*)regex {
    bestRegex = regex;
}

-(void) save_game_data {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:game_type forKey:@"saved_game_type"];
    [userDefaults setInteger:max_guesses forKey:@"saved_max_guesses"];
    [userDefaults setInteger:word_length forKey:@"saved_word_length"];
    [userDefaults setInteger:curr_guesses forKey:@"saved_curr_guesses"];
    [userDefaults setInteger:right_guesses forKey:@"saved_right_guesses"];
    [userDefaults setObject:wrong_letters forKey:@"saved_wrong_letters"];
    [userDefaults setObject:right_letters forKey:@"saved_right_letters"];
    [userDefaults setObject:secret_word forKey:@"saved_secret_word"];
    [userDefaults setObject:setWith forKey:@"saved_setWith"];
}

-(game*) load_game_data {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    game *newGame = [game alloc];
    newGame->game_type = [[userDefaults objectForKey:@"saved_game_type"]intValue];
    newGame->max_guesses = [[userDefaults objectForKey:@"saved_max_guesses"]intValue];
    newGame->word_length = [[userDefaults objectForKey:@"saved_word_length"]intValue];
    newGame->curr_guesses = [[userDefaults objectForKey:@"saved_curr_guesses"]intValue];
    newGame->right_guesses = [[userDefaults objectForKey:@"saved_right_guesses"]intValue];
    newGame->wrong_letters = [userDefaults objectForKey:@"saved_wrong_letters"];
    newGame->right_letters = [userDefaults objectForKey:@"saved_right_letters"];
    newGame->secret_word = [userDefaults objectForKey:@"saved_secret_word"];
    newGame->setWith = [userDefaults objectForKey:@"saved_setWith"];    
    return newGame;
}

@end
