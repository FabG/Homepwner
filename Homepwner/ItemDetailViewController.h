//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Possession;

@class ItemDetailViewController;
// create a delegate protocol for ItemDetailViewController and give it a delegate property. Although the
// ItemsViewController will serve as the delegate, using the delegate pattern will allow any object to present the
// ItemDetailViewController and be informed when it is dismissed.
@protocol ItemDetailViewControllerDelegate <NSObject>
@optional
- (void)itemDetailViewControllerWillDismiss:(ItemDetailViewController *)vc; @end

@interface ItemDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *serialNumberField;
    IBOutlet UITextField *valueField;
    IBOutlet UILabel *dateLabel;

    __weak IBOutlet UIButton *assetTypeButton;
    
    IBOutlet UIImageView *imageView;
    
    Possession *possession;
    
    UIPopoverController *imagePickerPopover; // for iPad only
}


// add an instance variable to hold the Possession that is being edited
@property (nonatomic, retain) Possession *possession;
@property (nonatomic, assign) id <ItemDetailViewControllerDelegate> delegate;

- (id)initForNewItem:(BOOL)isNew;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)showAssetTypePicker:(id)sender;


@end
