//
//  evilGamePlay.m
//  project2
//
//  Created by Bobby Odenhoven on 10-03-13.
//
//

#import "evilGamePlay.h"

@implementation evilGamePlay

-(NSMutableArray*) gamePlayDelegate: (NSString*)letter inWords: (NSMutableArray*)setWith wordLength:(int)word_length{
    NSLog(@"setWith before %d", [setWith count]);
    NSMutableArray *returning = [[NSMutableArray alloc] init];
    NSMutableArray *new_setWith = [[NSMutableArray alloc]init];
    
    /* Regex to match the guessed letters with */
    NSMutableArray *regexes = [[NSMutableArray alloc]init];
    /* Number of letters in the regex */
    NSMutableArray *nrOfRegexes = [[NSMutableArray alloc]init];
    
    NSString *regex = @"";
    int rightGuess = 0;
    
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
    int guessed_once = 0;
    int double_letter = 0;
    
    if (rightGuess == 1) {
        for (int i = 0; i < [bestRegex length]; i++) {
            char subTest = [bestRegex characterAtIndex:i];
            NSString *temp2 = [[NSString alloc] initWithFormat:@"%c",subTest];
            if ([temp2 isEqualToString:letter] && guessed_once == 1) {
                double_letter = 1;
            }
            else if ([temp2 isEqualToString:letter]) {
                guessed_once = 1;
            }
        }
    }
    
    new_setWith = setWithTemp;
    
    if (rightGuess == 0) {
        [returning addObject:[NSNumber numberWithInt:0]];
        /* Return the new set of words */
        [returning addObject:new_setWith];
    }
    else {
        /* Letter was guessed */
        [returning addObject:[NSNumber numberWithInt:1]];
        /* Return the best regex */
        [returning addObject:bestRegex];
        /* Return the new set of words */
        [returning addObject:new_setWith];
        /* A double letter was guessed */
        if (double_letter == 1) {
            [returning addObject:@"double_letter_guessed"];
        }
    }
    return returning;
}
@end
