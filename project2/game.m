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
    wrong_letters = malloc(word_length*sizeof(char));
    
    /* Read the word.plist file into an array */
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *allWords = [[NSArray alloc] initWithContentsOfFile:myFile];
    
    /* If this is a normal hangman game, choose a secret word */
    if (game_type == 0) {
        /* Load plist into array and choose random word */
        NSMutableArray *array_with_word_size;
        int randomIndex = (arc4random()%[array_with_word_size count]);
        
        /* Find all words with a length that is the same as the word_length setting */
        for (int i=0; i<[allWords count]; i++) {
            if ([[allWords objectAtIndex:i] length] == word_length) {
                [array_with_word_size addObject:[allWords objectAtIndex:i]];
            }
        }
        
        secret_word = [array_with_word_size objectAtIndex:randomIndex];
        NSLog(@"The secret word is %@", secret_word);
    }
    /* This is an evil hangman game */
    else {
        /* Store all words of the word length setting in a list that we need for the evil hangman algorithm */
        for (int i = 0; i < [allWords count]; i++) {
            NSString *temp = [allWords objectAtIndex:i];
            if ([temp length] == word_length) {
                [setWith addObject:temp];
            }
        }
        
        /* Create an empty regex, used for the evil hangman algorithm */
        regexes = [[NSMutableArray alloc] init];
        nrOfRegexes = [[NSMutableArray alloc] init];        
        NSString *tempRegex = @"";
        for (int i = 0; i < word_length; i++) {
            [tempRegex stringByAppendingString:@"-"];
        }
        [regexes addObject:tempRegex];
        [nrOfRegexes addObject:[NSNumber numberWithInt:0]];
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

-(int) get_curr_guesses {
    return curr_guesses;
}

-(char*) get_wrong_letters {
    return wrong_letters;
}

/* Guess a letter: check if the letter is in the word that needs to be guessed */
-(void) guessLetter: (char)letter {
}


@end
