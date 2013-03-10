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
    /* Current number of right guesses */
    int right_guesses;
    /* Array that holds the letters that were guessed wrong */
    NSMutableArray *wrong_letters;
    /* Array that holds the lettesr that were guessed correctly */
    NSMutableArray *right_letters;
    
    /* -- Normal hangman variables -- */
    /* The secret word */
    NSString *secret_word;
    
    /* -- Evil hangman variables -- */
    /* Array with all words of word_length length */
    NSMutableArray *setWith;

}

-(id)init;
-(int) get_game_type;

-(int) get_max_guesses;

-(int) get_word_length;

-(NSString*) get_secret_word;

-(NSMutableArray*) get_setWords;
-(void) set_setWords:(NSMutableArray*)setWords;

-(int) get_curr_guesses;
-(void) set_curr_guesses:(int)value;

-(int) get_right_guesses;
-(void) set_right_guesses:(int)value;

-(NSMutableArray*) get_wrong_letters;
-(void) set_wrong_letters:(NSString*)letter;

-(NSMutableArray*) get_right_letters;
-(void) set_right_letters:(NSString*)letter;

@end
