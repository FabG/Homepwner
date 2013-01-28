//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "ItemDetailViewController.h"

#import "Possession.h"

@implementation ItemDetailViewController

@synthesize possession;

// Override viewDidLoad 
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

// When the ItemDetailViewController’s view appears on the screen, it needs to set the values
// of its subviews to match the properties of the possession.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [nameField setText:[possession possessionName]];
    [serialNumberField setText:[possession serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d",
                         [possession valueInDollars]]];
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:
     [dateFormatter stringFromDate:[possession dateCreated]]];
    // Change the navigation item to display name of possession
    [[self navigationItem] setTitle:[possession possessionName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder - resign  first responder status - keyboard to be dismissed. 
    [[self view] endEditing:YES];
    
    // "Save" changes to possession
    [possession setPossessionName:[nameField text]];
    [possession setSerialNumber:[serialNumberField text]];
    [possession setValueInDollars:[[valueField text] intValue]];
}

@end
