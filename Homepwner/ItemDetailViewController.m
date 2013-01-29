//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Possession.h"
#import "ImageStore.h"
#import "PossessionStore.h"

@implementation ItemDetailViewController

@synthesize possession;
@synthesize delegate;

// Override viewDidLoad 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set background color depending on device: iPhone Vs iPad
    UIColor *clr = nil;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    
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
    
    // When ItemDetailViewController’s view appears on the screen, it should
    // grab an image from the ImageStore using the imageKey of the Possession.
    // Then, it should place the image in the UIImageView.
    NSString *imageKey = [possession imageKey];
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay =
        [[ImageStore defaultImageStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
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

- (IBAction)takePicture:(id)sender {
    NSLog(@"takePicture Action");

    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@" - Source = Camera");
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else
    {
        NSLog(@" - Source = PhotoLibrary");
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This line of code will generate 2 warnings right now, ignore them
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen

    
    // Place image picker on the screen - condition for iPad with UIPopover
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc]
                              initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        // Display the popover controller, sender
        // is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        // Note: presentModalViewcontroller is depricated with iOS 6
        [self presentModalViewController:imagePicker animated:YES];
    }
    
    [imagePicker release];
}

// iPad method for Popover dismissal
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    [imagePickerPopover autorelease];
    imagePickerPopover = nil;
}


- (IBAction)backgroundTapped:(id)sender {
    NSLog(@"Background tapped action");
    [[self view] endEditing:YES];
}

// Delegate for when the picture is taken
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    NSString *oldKey = [possession imageKey];
    
    // Did the possession already have an image?
    if (oldKey) {
        // Delete the old image
        [[ImageStore defaultImageStore] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);
    
    // Create a string from unique identifier
    // Leveraging some C functions
    CFStringRef newUniqueIDString =
    CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our possessions imageKey
    [possession setImageKey:( NSString *)newUniqueIDString];
    
    // We used "Create" in the functions to make objects, we need to release them
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    // Store image in the ImageStore with this key
    [[ImageStore defaultImageStore] setImage:image
                                      forKey:[possession imageKey]];
    
    // Put that image onto the screen in our image view
    [imageView setImage:image];
    
    // Take image picker off the screen
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // you must call this dismiss method - depricated in iOS 6
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [imagePickerPopover dismissPopoverAnimated:YES];
        [imagePickerPopover autorelease];
        imagePickerPopover = nil;
    }
}

// Dismissing the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Method for iPad so app works in all orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}

// If the ItemDetailViewController is being used to create a new Possession, it will show a Done button
// and a Cancel button on its navigation item.
- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"ItemDetailViewController" bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            [doneItem release];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            [cancelItem release];
        }
    }
    return self;
}

// This code creates an autoreleased instance of NSException with a name and a reason and then throws an exception.
// This halts the application and shows the exception in the console.
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (IBAction)save:(id)sender
{
    // This message gets forwarded to the parentViewController
    [self dismissModalViewControllerAnimated:YES];
    
    // Because the delegate method is optional, use respondsToSelector: to make sure the delegate implements
    // the method before we call it.
    if([delegate respondsToSelector:@selector(itemDetailViewControllerWillDismiss:)])
        [delegate itemDetailViewControllerWillDismiss:self];
}

- (IBAction)cancel:(id)sender
{
    // If the user cancelled, then remove the Possession from the store
    [[PossessionStore defaultStore] removePossession:possession];
    // This message gets forwarded to the parentViewController
    [self dismissModalViewControllerAnimated:YES];
    
    if([delegate respondsToSelector:@selector(itemDetailViewControllerWillDismiss:)])
        [delegate itemDetailViewControllerWillDismiss:self];
}

@end
