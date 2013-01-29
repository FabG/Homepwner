//
//  PossessionStore.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/27/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "PossessionStore.h"
#import "Possession.h"
#import "ImageStore.h"

// When defaultStore message is sent to the PossessionStore class, the class
// will check to see if the instance of PossessionStore has already been
// created. If the store exists, the class will return the instance. If
// not, it will create the instance and return it. To do this, you’ll use a
// global static variable.
static PossessionStore *defaultStore = nil;

@implementation PossessionStore
// Implement +defaultStore, +allocWithZone: and -init so that only one instance
// of the class can be created.

+ (PossessionStore *)defaultStore
{
    if (!defaultStore) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init {
    // If we already have an instance of PossessionStore...
    if (defaultStore) {
        // Return the old one
        return defaultStore;
    }
    
    self = [super init];
    
    // Read in Homepwner.xcdatamodeld
    model = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    //NSLog(@"model = %@", model);
    
    NSPersistentStoreCoordinator *psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // Where does the SQLite file go?
    NSString *path = pathInDocumentDirectory(@"store.data");
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeURL
                                 options:nil
                                   error:&error]) {
            [NSException raise:@"Open failed"
                    format:@"Reason: %@", [error localizedDescription]];
         }

    // Create the managed object context
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    [psc release];

    // The managed object context can manage undo, but we don't need it
    [context setUndoManager:nil];
    return self;

}
    
- (NSArray *)allPossessions
{
    // This ensures allPossessions is created
    [self fetchPossessionsIfNecessary];
    
    return allPossessions;
}

- (Possession *)createPossession
{
    // This ensures allPossessions is created
    [self fetchPossessionsIfNecessary];
    
    /* Using SQL Lite instead
    Possession *p = [Possession randomPossession];
    [allPossessions addObject:p];
    return p;
     */
    
    double order;
    if ([allPossessions count] == 0) {
        order = 1.0;
    } else {
        order = [[[allPossessions lastObject] orderingValue] doubleValue] + 1.0;
    }
    
    NSLog(@"Adding after %d items, order = %.2f",[allPossessions count], order);
    
    Possession *p = [NSEntityDescription insertNewObjectForEntityForName:@"Possession"
                                                  inManagedObjectContext:context];
    
    [p setOrderingValue:[NSNumber numberWithDouble:order]];
    [allPossessions addObject:p];
    
    return p;
}

- (void)removePossession:(Possession *)p
{
    // When a Possession is removed from the store, its image should also be
    // removed from the filesystem.
    NSString *key = [p imageKey];
    [[ImageStore defaultImageStore] deleteImageForKey:key];
    [context deleteObject:p];   // SQL Lite
    [allPossessions removeObjectIdenticalTo:p];
}


// SQL Lite - using orderingValue as a double to do it
// Take the orderingValues of the Possession that will be before and after the moving
// possession, add them together, and divide by two. Thus, the new orderingValue will
// fall directly in between the values of the Possessions that surround it.
- (void)movePossessionAtIndex:(int)from
                      toIndex:(int)to
{
    if (from == to) {
        return; }
    // Get pointer to object being moved
    Possession *p = [allPossessions objectAtIndex:from];
    // Retain it... (retain count of p = 2)

    [allPossessions removeObjectAtIndex:from];
    
    // Insert p in array at new location, retained by array (retain count of p = 2)
    [allPossessions insertObject:p atIndex:to];
    
    // SQL Lite: computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (to > 0) {
        lowerBound = [[[allPossessions objectAtIndex:to - 1]
                       orderingValue] doubleValue];
    } else {
        lowerBound = [[[allPossessions objectAtIndex:1]
                       orderingValue] doubleValue] - 2.0;
                       }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (to < [allPossessions count] - 1) {
        upperBound = [[[allPossessions objectAtIndex:to + 1]
                       orderingValue] doubleValue];
    } else {
        upperBound = [[[allPossessions objectAtIndex:to - 1]
                       orderingValue] doubleValue] + 2.0;
    }
    
    // The order value will be the midpoint between the lower and upper bounds
    NSNumber *n = [NSNumber numberWithDouble:(lowerBound + upperBound)/2.0];
    NSLog(@"moving to order %@", n);
    
    [p setOrderingValue:n];
    
    // Release p (retain count = 1, only owner is now array)
    [p release];
    
}

- (NSString *)possessionArchivePath
{
    // The returned path will be Sandbox/Documents/possessions.data
    // Both the saving and loading methods will call this method to get the same path,
    // preventing a typo in the path name of either method
    return pathInDocumentDirectory(@"possessions.data");
}


// The archiveRootObject:toFile: method creates an instance of NSKeyedArchiver and
// then sends encodeWithCoder: to allPossessions. The NSKeyedArchiver is passed as
// the argument. When an array is archived, all of its contents are archived along
// with it (as long as those contents conform to NSCoding), so passing an array full
// of Possession instances to archiveRootObject:toFile: kicks off a chain reaction of
// encoding.
- (BOOL)saveChanges
{
    // returns success or failure
    /* Using SQL Lite instead
     return [NSKeyedArchiver archiveRootObject:allPossessions
                                       toFile:[self possessionArchivePath]];
     */
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (void)fetchPossessionsIfNecessary
{
    /* Using SQL Lite instead
    // If we don't currently have an allPossessions array, try to read one from disk
    if (!allPossessions) {
        NSString *path = [self possessionArchivePath];
        allPossessions = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    // If we tried to read one from disk but does not exist, then create a new one
    if (!allPossessions) {
        allPossessions = [[NSMutableArray alloc] init];
    }
    */
    if (!allPossessions) {
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Possession"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        allPossessions = [[NSMutableArray alloc] initWithArray:result];
    }
}

// SQL Lite - Asset type
// If this is the first time the application is being run – and therefore there are no
// AssetTypes in the store – create three default types.
- (NSArray *)allAssetTypes
{
    if (!allAssetTypes) {
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"AssetType"];
        [request setEntity:e];
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        allAssetTypes = [result mutableCopy];
    }
    
    // Is this the first time the program is being run?
    if ([allAssetTypes count] == 0) {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Furniture" forKey:@"label"];
        [allAssetTypes addObject:type];
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [allAssetTypes addObject:type];
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Electronics" forKey:@"label"];
        [allAssetTypes addObject:type];
    }
    return allAssetTypes;
}
        
@end
