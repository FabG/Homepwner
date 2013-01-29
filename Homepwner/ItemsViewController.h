//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/27/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemDetailViewController.h"
#import "ItemDetailViewController.h"

@interface ItemsViewController : UITableViewController <ItemDetailViewControllerDelegate>
{
    IBOutlet UIView *headerView;
}

- (UIView *)headerView;

- (IBAction)addNewPossession:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;

@end
