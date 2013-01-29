//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/27/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "ItemsViewController.h"
#import "PossessionStore.h"
#import "Possession.h"
#import "HomepwnerItemCell.h"

@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    /* Commenting out as we can add the possessions one by one
    // Add 10 random possessions to the PossessionStore.
    if (self) {
        for (int i = 0; i < 10; i++) {
            [[PossessionStore defaultStore] createPossession];
        }
    }
     */
    
    // Give Homepwner a UINavigationBar with a button
    // When tapped, it will add a new Possession to the list.
    if (self) {
        // Create a new bar button item that will send
        // addNewPossession: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewPossession:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];

        // Set the title of the navigation item
        [[self navigationItem] setTitle:@"Homepwner"];
        
        // Replace the Edit button in the table view header with a
        // UIBarButtonItem.
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

// Implement tableView:numberOfRowsInSection (Obtaining number of rows)
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[PossessionStore defaultStore] allPossessions] count];
}


// Each cell will display the description of a Possession as its textLabel.
// Implement tableView:cellForRowAtIndexPath: so that the nth row displays
// the nth entry in the allPossessions array.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Commenting out as we ar enow using Images & HomepwnerItemCells
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:@"UITableViewCell"];
    }
    
    // Set the text on the cell with the description of the possession
    // that is at the nth index of possessions, where n = row this cell
    // will appear in on the tableview
    Possession *p = [[[PossessionStore defaultStore] allPossessions]
                     objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[p description]];
     */
    
    // Get instance of a HomepwnerItemCell - either an unused one or a new one.
    // The method returns a UITableViewCell; we typecast it as a HomepwnerItemCell.
    HomepwnerItemCell *cell = (HomepwnerItemCell *)[tableView
                                dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    if (!cell) {
        cell = [[[HomepwnerItemCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:@"HomepwnerItemCell"] autorelease];
    }
    
    NSArray *possessions = [[PossessionStore defaultStore] allPossessions];
    Possession *p = [possessions objectAtIndex:[indexPath row]];
    
    // Instead of setting each label directly, we pass it a possession object
    // it knows how to configure its own subviews
    [cell setPossession:p];
    
    return cell;
}

// Load a XIB file manually with NSBundle. This class is the interface between an
// application and the application bundle it lives in.
// Implement headerView.
- (UIView *)headerView
{
    // If we haven't loaded the headerView yet...
    if (!headerView) {
        // Load HeaderView.xib (self as owner of the XIB file places the instance
        // of ItemsViewController as the File's Owner of the XIB file
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}


// Make the XIB header view of the table

/* Commenting out this section as we add th edit and + buttons to navigation bar
// The first time tableView:heightForHeaderInSection: is sent to
// ItemsViewController, it sends itself the message headerView. At this time,
// headerView will be nil, which causes headerView to be loaded from the XIB file
- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec
{
    return [[self headerView] bounds].size.height;
}
 */


// Implement both button actions
- (void)toggleEditingMode:(id)sender
{
    // If we are currently in editing mode...
    if ([self isEditing]) {
        NSLog(@"EDIT Mode = ON");
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        NSLog(@"EDIT Mode = OFF");
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}
 

// Implement the action method for the New button so that a new random
// Possession is added to the store and the table is reloaded.
- (IBAction)addNewPossession:(id)sender
{
    /* Before ading the modal screens
    [[PossessionStore defaultStore] createPossession];
    // tableView returns the controller's view
    [[self tableView] reloadData];
     */
    
    // method to create an instance of ItemDetailViewController in a UINavigationController
    // and present the navigation controller modally
    Possession *newPossession = [[PossessionStore defaultStore] createPossession];
    ItemDetailViewController *detailViewController =
    [[ItemDetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setDelegate:self];
    [detailViewController setPossession:newPossession];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    // method to change the presentation style of the UINavigationController that is being presented.
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    // navController is retained by self when presented
    [self presentModalViewController:navController animated:YES];
    
}

// DELETE ROWS
// Implement protocol  from UITableViewDataSource protocol:
// tableView:commitEditingStyle:forRowAtIndexPath:
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"DELETE Possession");
        PossessionStore *ps = [PossessionStore defaultStore];
        NSArray *possessions = [ps allPossessions];
        Possession *p = [possessions objectAtIndex:[indexPath row]];
        [ps removePossession:p];
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:YES];
    }
}

// MOVE ROWS
// Implement tableView:moveRowAtIndexPath:toIndexPath: to update the store.
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"MOVE Possession");
    [[PossessionStore defaultStore] movePossessionAtIndex:[fromIndexPath row]
                                                  toIndex:[toIndexPath row]];
}

// When a row is tapped, its delegate is sent tableView:didSelectRowAtIndexPath:,
// which contains the index path of the selected row.
// Implement this method to allocate a ItemDetailViewController and then push it on top of
// the navigation controller’s stack.
- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    ItemDetailViewController *detailViewController =
    [[ItemDetailViewController alloc] initForNewItem:NO];
    
    /* Old initializer
    ItemDetailViewController *detailViewController =
    [[ItemDetailViewController alloc] init];
    */
    
    NSArray *possessions = [[PossessionStore defaultStore] allPossessions];
    
    // Give detail view controller a pointer to the possession object in row
    [detailViewController setPossession:
     [possessions objectAtIndex:[indexPath row]]];
    
    // Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

// reload  UITableView so the user can see the changes from the detailled edit view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
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

// implement the method from the delegate protocol to reload the table.
- (void)itemDetailViewControllerWillDismiss:(ItemDetailViewController *)vc
{
    [[self tableView] reloadData];
}


@end
