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
    NSLog(@"in game init");
    NSLog(@"game_type %f", [[userDefaults valueForKey:@"game_type"]floatValue]);
    NSLog(@"max_guesses %f", [[userDefaults valueForKey:@"max_guesses"]floatValue]);
    NSLog(@"word_length %f", [[userDefaults valueForKey:@"word_length"]floatValue]);
    
    game_type = [[userDefaults objectForKey:@"game_type"] intValue];
    max_guesses = [[userDefaults objectForKey:@"max_guesses"] intValue];
    word_length = [[userDefaults objectForKey:@"word_length"] intValue];
    curr_guesses = 0;
    wrong_letters = [[NSMutableArray alloc]init];
    right_letters = [[NSMutableArray alloc]init];
    
    /* Read the word.plist file into an array */
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *allWords = [[NSArray alloc] initWithContentsOfFile:myFile];
    //NSArray *allWords = [[NSArray alloc] initWithObjects:@"BOAR", @"DUCK", @"BEAR", @"DEER", @"HARE", nil];
    
    /* If this is a normal hangman game, choose a secret word */
    if (game_type == 1) {
        /* Load plist into array and choose random word */
        NSMutableArray *array_with_word_size = [[NSMutableArray alloc]init];
        
        /* Find all words with a length that is the same as the word_length setting */
        for (int i=0; i<[allWords count]; i++) {
            //NSLog(@"item length %d word length %d", [[allWords objectAtIndex:i]length], word_length);
            if ([[allWords objectAtIndex:i] length] == word_length) {
                [array_with_word_size addObject:[allWords objectAtIndex:i]];
            }
        }
        NSLog(@"allWords size %d, array_with_word_size %d", [allWords count], [array_with_word_size count]);
        int randomIndex = (arc4random()%[array_with_word_size count]);
        NSLog(@"random_index %d length of allWords %d random word %@", randomIndex, [array_with_word_size count], [array_with_word_size objectAtIndex:randomIndex]);
        secret_word = [NSString stringWithFormat:@"%@", [array_with_word_size objectAtIndex:randomIndex]];
        NSLog(@"The secret word is %@", secret_word);
    }
    /* This is an evil hangman game */
    else {
        /* Store all words of the word length setting in a list that we need for the evil hangman algorithm */
        NSLog(@"4");
        setWith = [[NSMutableArray alloc]init];
        for (int i = 0; i < [allWords count]; i++) {
            NSString *temp = [allWords objectAtIndex:i];
            if ([temp length] == word_length) {
                [setWith addObject:temp];
            }
        }
        
        NSLog(@"after init setWith count: %d", [setWith count]);
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


/* Guess a letter for a normal hangman game: check if the letter is in the word that needs to be guessed */
-(NSMutableArray*) guessLetterNormal: (NSString*)letter {
	NSMutableArray *returning = [[NSMutableArray alloc] init];
    NSString *guessed_word = @"";
    int guessed_bool = 0;
    
    for (int i = 0; i < [secret_word length]; i++) {
        char subTest = [secret_word characterAtIndex:i];
        NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest];
        if ([letter isEqualToString:temp]) {
            guessed_word = [guessed_word stringByAppendingString:letter];
            guessed_bool = 1;
        }
        else {
            guessed_word = [guessed_word stringByAppendingString:@"-"];
        }
    }
    
    /* Return a boolean stating that the letter was right guessed and if so, return a regex with the guessed letters on the right places */
    if (guessed_bool) {
        [returning addObject:[NSNumber numberWithBool:YES]];
        [returning addObject:guessed_word];
    }
    else {
        [returning addObject:[NSNumber numberWithBool:NO]];
    }
    return returning;    
}

/* Guess a letter for an evil hangman game: check if the letter is in the word that needs to be guessed */
-(NSMutableArray*) guessLetterEvil: (NSString*)letter {
    NSMutableArray *returning = [[NSMutableArray alloc] init];
    
    NSString *regex = @"";
    int rightGuess = 0;
    
    [regexes removeAllObjects];
    [nrOfRegexes removeAllObjects];
    
    NSString *tempRegex = @"";
    for (int i = 0; i < word_length - 1; i++) {
        [tempRegex stringByAppendingString:@"-"];
    }
    [regexes addObject:tempRegex];
    [nrOfRegexes addObject:[NSNumber numberWithInt:0]];
    
    //Loop through all the words
    for (int i = 0; i < [setWith count]; i++) {
        NSString *temp = [setWith objectAtIndex:i];
        regex = @"";
        //Size of secret word must be the same as current word from plist
        if ([temp length] == word_length) {
            int found = 0;
            for (int j = 0; j < word_length; j++) {
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
    for (int i = 0; i < word_length; i++) {
        emptyRegex = [emptyRegex stringByAppendingString:@"-"];
    }
    int max = 0;
    int maxAtIndex = 0;
    NSString *bestRegex = @"";
    if ([nrOfRegexes count] > 1) {
        for (int i = 0; i < [nrOfRegexes count]; i++) {
            if ([[nrOfRegexes objectAtIndex:i] intValue] > max) {
                max = [[nrOfRegexes objectAtIndex:i] intValue];
                maxAtIndex = i;
            }
        }
        bestRegex = [regexes objectAtIndex:maxAtIndex];
        if (![bestRegex isEqualToString:emptyRegex]) {
            rightGuess = 1;
        }
    }
    /* There is but one regex: the empty one. The letter doesn't exist in the word. Wrong guess. */
    else {
        bestRegex = emptyRegex;       
    }
    
    int noLetter = 0;
    
    if ([bestRegex isEqualToString:emptyRegex]) {
        noLetter = 1;
    }
    
    /* The words that fit the regex, must become the new setWith. */
    int noFit;
    NSMutableArray *setWithTemp = [[NSMutableArray alloc] init];
    if (noLetter != 1) {
        for (int i = 0; i < [setWith count]; i++) {
            noFit = 0;
            NSString *temp = [setWith objectAtIndex:i];
            for (int j = 0; j < [temp length]; j++) {
                /* Split letters into individual chars */
                char subTestTemp = [temp characterAtIndex:j];
                NSString *tempChar = [[NSString alloc] initWithFormat:@"%c",subTestTemp];
                char subTestRegex = [bestRegex characterAtIndex:j];
                NSString *regexChar = [[NSString alloc] initWithFormat:@"%c",subTestRegex];
                /* Compare chars */
                if (![tempChar isEqualToString:regexChar] && ![regexChar isEqualToString:@"-"]) {
                    noFit = 1;
                }
            }
            if (noFit == 0) {
                [setWithTemp addObject:temp];
            }
        }
    }
    /* The empty regex was the most found one */
    else {
        for (int i = 0; i < [setWith count]; i++) {
            NSString *temp = [setWith objectAtIndex:i];
            /* The word in setWith doesn't contain the letter, so add it */
            if ([temp rangeOfString:letter].location == NSNotFound) {
                [setWithTemp addObject:temp];
            }
        }
    }   
    
    setWith = setWithTemp;
        
    if (rightGuess == 0) {
        [returning addObject:[NSNumber numberWithInt:0]];
    }
    else {
        [returning addObject:[NSNumber numberWithInt:1]];
        [returning addObject:bestRegex];
    }
    return returning;
    
}

@end
