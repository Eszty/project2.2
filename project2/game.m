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
    
    /* Read the word.plist file into an array */
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *allWords = [[NSArray alloc] initWithContentsOfFile:myFile];
    
    /* If this is a normal hangman game, choose a secret word */
    if (game_type == 1) {
        /* Load plist into array and choose random word */
        NSMutableArray *array_with_word_size;
        int randomIndex = (arc4random()%[allWords count]);
        
        NSLog(@"1");
        /* Find all words with a length that is the same as the word_length setting */
        for (int i=0; i<[allWords count]; i++) {
            if ([[allWords objectAtIndex:i] length] == word_length) {
                [array_with_word_size addObject:[allWords objectAtIndex:i]];
            }
        }
        NSLog(@"2");
        secret_word = [array_with_word_size objectAtIndex:randomIndex];
        NSLog(@"3");
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

/* Guess a letter for a normal hangman game: check if the letter is in the word that needs to be guessed */
-(NSMutableArray*) guessLetterNormal: (NSString*)letter {
    
}

/* Guess a letter for an evil hangman game: check if the letter is in the word that needs to be guessed */
-(NSMutableArray*) guessLetterEvil: (NSString*)letter {
    NSMutableArray *guessArray = [[NSMutableArray alloc]init];
    
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
    if ([nrOfRegexes count] > 2) {
        for (int i = 0; i < [nrOfRegexes count]; i++) {
            if ([[nrOfRegexes objectAtIndex:i] intValue] > max && ![[regexes objectAtIndex:i] isEqualToString:emptyRegex]) {
                max = [[nrOfRegexes objectAtIndex:i] intValue];
                maxAtIndex = i;
            }
        }
        bestRegex = [regexes objectAtIndex:maxAtIndex];
        rightGuess = 1;
    }
    /* There is but one regex: the empty one. The letter doesn't exist in the word. Wrong guess. */
    else {
        bestRegex = emptyRegex;
        
    }
    for (int i = 0; i < [nrOfRegexes count]; i++) {
        NSLog(@"nrRegex on %d: %d with regex: %@", i, [[nrOfRegexes objectAtIndex:i] intValue], [regexes objectAtIndex:i]);
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
        setWith = setWithTemp;
    }
    
	NSMutableArray *returning = [[NSMutableArray alloc] init];
    
    if (rightGuess == 0) {
        [returning addObject:[NSNumber numberWithBool:NO]];
    }
    else {
        [returning addObject:[NSNumber numberWithBool:YES]];
        [returning addObject:bestRegex];
    }
    return returning;
    
}

@end
