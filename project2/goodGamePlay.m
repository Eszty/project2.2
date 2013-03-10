//
//  goodGamePlay.m
//  project2
//
//  Created by Bobby Odenhoven on 10-03-13.
//
//

#import "goodGamePlay.h"

@implementation goodGamePlay


/* Guess a letter for a normal hangman game: check if the letter is in the word that needs to be guessed */
-(NSMutableArray*) gamePlayDelegate: (NSString*)letter inWord: (NSString*)secret_word {
	NSMutableArray *returning = [[NSMutableArray alloc] init];
    NSString *guessed_word = @"";
    int guessed_bool = 0;
    int letter_guessed_once = 0;
    int double_letter = 0;
    
    for (int i = 0; i < [secret_word length]; i++) {
        char subTest = [secret_word characterAtIndex:i];
        NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest];
        /* Letter was once in the word already, so that's a double letter */
        if ([letter isEqualToString:temp] && letter_guessed_once == 1) {
            guessed_word = [guessed_word stringByAppendingString:letter];
            guessed_bool = 1;
            double_letter = 1;
        }
        /* First time this letter is found in the word */
        else if ([letter isEqualToString:temp]) {
            guessed_word = [guessed_word stringByAppendingString:letter];
            guessed_bool = 1;
            letter_guessed_once = 1;
        }
        else {
            guessed_word = [guessed_word stringByAppendingString:@"-"];
        }
    }
    
    /* Return a boolean stating that the letter was right guessed and if so, return a regex with the guessed letters on the right places */
    if (guessed_bool) {
        [returning addObject:[NSNumber numberWithBool:YES]];
        [returning addObject:guessed_word];
        if (double_letter == 1) {
            [returning addObject:@"double_letter_guessed"];
        }
    }
    else {
        [returning addObject:[NSNumber numberWithBool:NO]];
    }
    return returning;
}

@end
