//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Possession;

@interface ItemDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *serialNumberField;
    IBOutlet UITextField *valueField;
    IBOutlet UILabel *dateLabel;

    IBOutlet UIImageView *imageView;
    
    Possession *possession;
}

// add an instance variable to hold the Possession that is being edited
@property (nonatomic, retain) Possession *possession;

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
