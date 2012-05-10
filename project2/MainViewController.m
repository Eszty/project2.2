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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*NSString* test = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary *wordsArray = [[NSMutableDictionary alloc] init];
    wordsArray = [[NSMutableDictionary alloc] initWithContentsOfFile: test]; */
    
    /*NSString *myFile = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSMutableDictionary* myDict = [[NSMutableDictionary alloc] initWithContentsOfFile:myFile];
    NSLog(@"%@", myDict);
    //NSArray *allkeys = [myDict allKeys];
    NSArray *allvalues = [myDict allValues];
    NSLog(@"%@", [allvalues objectAtIndex:1]);*/
    
    

    /*NSMutableArray *char_array = [NSMutableArray arrayWithCapacity: [temp length]];
    for (int i = 0; i < [char_array count]; i++) {
        NSString s = [temp characterAtIndex:1];
        [char_array addObject:s];        
    }
    const char *char_array = [temp UTF8String];
    NSLog(@"%lu", sizeof(char_array));
    NSLog(@"%c", char_array[1]);
     */
        
    NSString *temp = @"hazelnoot";
    

    
    

    
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
- (NSString*)buttonPressed:(id)sender:(id)nr_of_letters {
    
    NSString *word = self.textField.text;
    int count = [word length];
    

    

    
    return word;
}

- (NSString*)guess:(id)sender {
    NSString *letter = self.textField.text;
    return letter;
}

- (void)guessTest:(id)first :(NSString *)letter second:(NSString *)word {
    /*
    NSString* ltr = letter;
    NSString* wrd = word;
    
    int cnt = [word length];
    
    for (int i = 0; i<=[word length]; i++) {
        if ([ltr isEqualToString:[wrd substringFromIndex:i]]) {
            [PArray replaceObjectAtIndex:i withObject:ltr];
        }
    }
    
    for(int i = 0; i < cnt; i++){
        UILabel *placeholderNew = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];
        
        placeholderNew.text = [PArray objectAtIndex:i];
        placeholderNew.backgroundColor = [UIColor clearColor];
        placeholderNew.textColor = [UIColor redColor];
        placeholderNew.font = [UIFont systemFontOfSize:30];
        
                
        [self.view addSubview:placeholderNew];
        
        [self.textField resignFirstResponder]; //close keyboard
        
    }

    */
    
}

/*
- (void)newGame:(id)sender {
    //TODO: clear placeholders, load new random word, create new placeholders
}
*/


@end
