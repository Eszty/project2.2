//
//  MainViewController.m
//  project2
//
//  Created by Eszter Fodor on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

NSString *retWord;
NSMutableArray *retArr;
NSMutableArray *wrongGuessArray;


@synthesize textField = _textField;
@synthesize button = _button;
@synthesize placeholder = _placeholder;
@synthesize guess = _guess;
@synthesize newgame = _newgame;
@synthesize nrguesses = _nrguesses;

//extern NSMutableArray *PArray; 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*NSString* test = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
     NSMutableDictionary *wordsArray = [[NSMutableDictionary alloc] init];
     wordsArray = [[NSMutableDictionary alloc] initWithContentsOfFile: test]; 
    
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary* myDict = [[NSMutableDictionary alloc] initWithContentsOfFile:myFile];
    NSLog(@"%@", myDict);
    NSArray *allkeys = [myDict allKeys];
    NSArray *allvalues = [myDict allValues];
    NSLog(@"%@", [allvalues objectAtIndex:1]);*/
    
    
    retWord = @"hazelnoot";
    
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [retWord length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        [pArray addObject: placeholder.text];
        
        [self.view addSubview:placeholder];
        
        [self.textField resignFirstResponder]; //close keyboard
        
    }
    retArr = [self returnArray:pArray];
    
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
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

//Creates placeholders for the input word
- (IBAction)buttonPressed:(id)sender {
    
    //NSString *word = self.textField.text;

}

/*- (NSString*)returnWord:word{
    NSString *wrd = word;
    return wrd;
}*/

- (NSMutableArray*)returnArray:array{
    NSMutableArray *arr = array;
    return arr;
}

- (IBAction)guess:(id)sender {
    NSString *letter = self.textField.text;
    [self guessTestWithFirst:letter second:retArr];
}

- (void)guessTestWithFirst:(NSString *)letter second:(NSMutableArray *)pArray {
    
    NSMutableArray *guessArray;
    int cnt = [retWord length];
    
    for (int i = 0; i<[retWord length]; i++) {
        char subTest = [retWord characterAtIndex:i];
        NSString *temp = [[NSString alloc] initWithFormat:@"%c",subTest]; 
        if ([letter isEqualToString:temp]) {
            [pArray replaceObjectAtIndex:i withObject:letter];
        }
        else {
            [guessArray addObject:temp];
        }
    }
    
    for(int i = 0; i < cnt; i++){
        UILabel *placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        
        placeholderNew.text = [pArray objectAtIndex:i];
        placeholderNew.backgroundColor = [UIColor clearColor];
        placeholderNew.textColor = [UIColor redColor];
        placeholderNew.font = [UIFont systemFontOfSize:30];
        
        
        [self.view addSubview:placeholderNew];
        
        [self.textField resignFirstResponder]; //close keyboard
        
    }
    //Update number of guesses
    int temp = [self.nrguesses.text intValue];
    temp++;
    if (temp == 10) {
        [self gameOver];
    }
    else  {
        self.nrguesses.text = [NSString stringWithFormat:@"%d", temp];
    }
    wrongGuessArray = [self returnArray:guessArray];
  
}

- (void) gameOver {
    UIAlertView *gameover = [[UIAlertView alloc] initWithTitle:@"Game over" 
                                                    message:@"You lost the game. Click OK to start a new game" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Quit game"
                                             otherButtonTitles:@"OK", nil];
    [gameover show];
}

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
    NSLog(@"Hallo");
    //reset nr guesses, load a new random word
    self.nrguesses.text = @"0";
    retWord = @"hazelnoot";
    
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [retWord length]; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        
        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        [pArray addObject: placeholder.text];
        
        [self.view addSubview:placeholder];
        
        [self.textField resignFirstResponder]; //close keyboard
        
    }
    retArr = [self returnArray:pArray];
    //TODO
    //Empty/remove placeholders that hold letters
 }


//TODO:
// - Display guessed letters
// - Only alphabetical + only 1 letter
// - Congratulate winner
// - Evil hangman
// - Settings
// - Read words.plist


@end
