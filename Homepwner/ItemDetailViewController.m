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
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This line of code will generate 2 warnings right now, ignore them
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    // Note: presentModalViewcontroller is depricated with iOS 6
    //[self presentModalViewController:imagePicker animated:YES];
    
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

// Delegate for when the picture is taken
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
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
    [possession setImageKey:(__bridge NSString *)newUniqueIDString];
    
    // We used "Create" in the functions to make objects, we need to release them
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    // Store image in the ImageStore with this key
    [[ImageStore defaultImageStore] setImage:image
                                      forKey:[possession imageKey]];
    
    // Put that image onto the screen in our image view
    //[imageView setImage:image];
    
    // Take image picker off the screen -
    // you must call this dismiss method - depricated in iOS 6
    //[self dismissModalViewControllerAnimated:YES];
}

// Dismissing the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
