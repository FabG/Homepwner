//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/29/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "AssetTypePicker.h"
#import "PossessionStore.h"
#import "Possession.h"

// This table view controller will show a list of the available AssetTypes. Tapping a button
// on the ItemDetailViewController’s view will display it (in a popover on the iPad and in a
// navigation controller on the iPhone). Implement the data source methods and import the
// appropriate header files in AssetTypePicker.m
@implementation AssetTypePicker

@synthesize possession;

- (id)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)dealloc
{
    [possession release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[PossessionStore defaultStore] allAssetTypes] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)ip
{
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"UITableViewCell"]
                                            autorelease];
    }
    
    NSArray *allAssets = [[PossessionStore defaultStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[ip row]];
    
    // Use key-value coding to get the asset type's label
    NSString *assetLabel = [assetType valueForKey:@"label"];
    [[cell textLabel] setText:assetLabel];
    
    // Checkmark the one that is currently selected
    if (assetType == [possession assetType]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}
                
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)ip
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:ip];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allAssets = [[PossessionStore defaultStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[ip row]];
    [possession setAssetType:assetType];
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
