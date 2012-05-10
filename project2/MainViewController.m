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


@synthesize textField = _textField;
@synthesize button = _button;
@synthesize placeholder = _placeholder;
@synthesize guess = _guess;
@synthesize newgame = _newgame;

//extern NSMutableArray *PArray; 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*NSString* test = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary *wordsArray = [[NSMutableDictionary alloc] init];
    wordsArray = [[NSMutableDictionary alloc] initWithContentsOfFile: test]; */
    
    NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary* myDict = [[NSMutableDictionary alloc] initWithContentsOfFile:myFile];
    NSLog(@"%@", myDict);
    NSArray *allkeys = [myDict allKeys];
    NSArray *allvalues = [myDict allValues];
    NSLog(@"%@", [allvalues objectAtIndex:1]);
    
    
    NSString *temp = @"hazelnoot";
    const char *char_array = [temp UTF8String];
    NSLog(@"%c", char_array[0]);
    NSLog(@"%c", char_array[1]);
    
    

    
    //Get item10 with value 'aardvark'
    //NSObject *randomWord = [wordsArray objectForKey:@"Item 6"];
    //NSLog(@"%@", randomWord);

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
    
    NSString *word = self.textField.text;
    int count = [word length];
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < count; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];

        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        [pArray addObject: placeholder.text];
        
        [self.view addSubview:placeholder];
        
        [self.textField resignFirstResponder]; //close keyboard

    }
    
    NSString *retWord = [self returnWord:word];
    NSMutableArray *retArr = [self returnArray:pArray];
}

- (NSString*)returnWord:word{
    NSString *wrd = word;
    return wrd;
}

- (NSMutableArray*)returnArray:array{
    NSMutableArray *arr = array;
    return arr;
}

- (IBAction)guess:(id)sender {
    NSString *letter = self.textField.text;
    //[self guessTest: letter retWord retArr];
}

- (void)guessTest:(id)first :(NSString *)letter second:(NSString *)word third:(NSMutableArray *)pArray {
    
    int cnt = [word length];
    
    for (int i = 0; i<=[word length]; i++) {
        if ([letter isEqualToString:[word substringFromIndex:i]]) {
            [pArray replaceObjectAtIndex:i withObject:letter];
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

    
    
}

/*
- (void)newGame:(id)sender {
    //TODO: clear placeholders, load new random word, create new placeholders
}
*/


@end
