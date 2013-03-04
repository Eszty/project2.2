//
//  game.h
//  project2
//
//  Created by Sammy Odenhoven on 2/27/13.
//
//

#import <Foundation/Foundation.h>

@interface game : NSObject {
    /* Game type: evil (0) or normal (1) */
    int game_type;
    /* Maximum ammount of wrong guesses */
    int max_guesses;
    /* Word length */
    int word_length;
    /* Current number of wrong guesses */
    int curr_guesses;
    /* Array that holds the letters that were guessed wrong */
    char *wrong_letters;
    
    /* -- Normal hangman variables -- */
    /* The secret word */
    NSString *secret_word;
    
    /* -- Evil hangman variables -- */
    /* Array with all words of word_length length */
    NSMutableArray *setWith;
    /* Regex to match the guessed letters with */
    NSMutableArray *regexes;
    /* Number of letters in the regex */
    NSMutableArray *nrOfRegexes;
    NSMutableArray *wrongGuessArray;

}

-(id)init;
-(game*) newGame;
-(void) guessLetter: (char)letter;
-(int) get_game_type;
-(int) get_max_guesses;
-(int) get_word_length;
-(int) get_curr_guesses;
-(char*) get_wrong_letters;

@end
