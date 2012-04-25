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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableDictionary *wordsArray = [[NSMutableDictionary alloc] initWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    
    //Get item10 with value 'aardvark'
    NSObject *randomWord = [wordsArray objectForKey:@"item 6"];
    NSLog(@"%@", randomWord);

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
- (void)buttonPressed:(id)sender {
    
    NSString *word = self.textField.text;
    int count = [word length];
    
    for(int i = 0; i < count; i++){
        UILabel *placeholder = [[UILabel alloc] initWithFrame: CGRectMake((10+30*i), 100, 100, 50)];

        placeholder.text = [NSString stringWithFormat:@"_"];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor redColor];
        placeholder.font = [UIFont systemFontOfSize:30];
        
        [self.view addSubview:placeholder];
        
        [self.textField resignFirstResponder]; //close keyboard

    }
    
    
    
    
    /*
    if ([self.textField.text isEqualToString:@"s"])	 {
        self.labelone.text = @"s";
        self.textField.text = @"";
    }*/
}

- (void)newGame:(id)sender {
    //TODO: clear placeholders, load new random word, create new placeholders
}



@end
